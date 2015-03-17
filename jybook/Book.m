//
//  Book.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "Book.h"
#import "ZipArchive.h"
#import "TBXML.h"

@interface Book ()
@property (nonatomic, strong) NSString *epubpath;
@property (nonatomic, strong) NSString *bookpath;
@property (nonatomic, strong) NSArray *bookspine;
@property (nonatomic, strong) NSDictionary *chapterTitleDict;
@property (nonatomic, strong) NSDictionary *chapterFileDict;

@end

@implementation Book

- (id) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.epubpath = [[NSBundle mainBundle] pathForResource:self.name ofType:@"epub" inDirectory:@"epub"];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.bookpath = [documentPath stringByAppendingPathComponent:self.name];
    }
    return self;
}


- (void)unzipBook {
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile:self.epubpath]) {
        BOOL ret = [za UnzipFileTo:self.bookpath overWrite:YES];
        if (NO == ret) {
            NSLog(@"unzip file from %@ to %@ failed", self.epubpath, self.bookpath);
        }
        [za UnzipCloseFile];
    }
}

- (NSString *) parseMetaContainerXml {
    //NSLog(@"----parse meta container xml");
    NSString *metapath = [self.bookpath stringByAppendingPathComponent:@"META-INF/container.xml"];    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:metapath]) {
        //NSLog(@"metapath %@ not exists", metapath);
        [self unzipBook];
    }

    NSString *metaString = [NSString stringWithContentsOfFile:metapath encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"meta container:%@", metaString);
    TBXML *metaxml = [TBXML tbxmlWithXMLString:metaString error:nil];
    TBXMLElement *root = metaxml.rootXMLElement;
    TBXMLElement *rootfiles = root->currentChild;
    if (rootfiles) {
        TBXMLElement *rootfile = rootfiles->firstChild;
        while (rootfile) {
            if ([[TBXML valueOfAttributeNamed:@"media-type" forElement:rootfile] isEqualToString:@"application/oebps-package+xml"]) {
                 return [self.bookpath stringByAppendingPathComponent:[TBXML valueOfAttributeNamed:@"full-path" forElement:rootfile]];

            } else {
                    rootfile = rootfile->nextSibling;
            }
        }
    }
    return nil;
}

- (NSString *)parseContentOpf {
    //NSLog(@"-----parse content opf-----");
    NSString *opfpath = [self parseMetaContainerXml];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:opfpath]) {
        NSLog(@"content opf file:%@ not exists", opfpath);
    }
    NSString *content = [NSString stringWithContentsOfFile:opfpath encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"content opf:%@", content);
    TBXML *contentxml = [TBXML tbxmlWithXMLString:content error:nil];
    
    TBXMLElement *manifest = [TBXML childElementNamed:@"manifest" parentElement:contentxml.rootXMLElement];
    TBXMLElement *item = manifest->firstChild;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    while (item) {
        NSString *itemid = [TBXML valueOfAttributeNamed:@"id" forElement:item];
        NSString *href = [TBXML valueOfAttributeNamed:@"href" forElement:item];
        [dict setObject:href forKey:itemid];
        item = item->nextSibling;
    }
    self.chapterFileDict = [NSDictionary dictionaryWithDictionary:dict];
    
    TBXMLElement *spine = [TBXML childElementNamed:@"spine" parentElement:contentxml.rootXMLElement];
    
    TBXMLElement *itemref = spine->firstChild;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while (itemref) {
        NSString *idref = [TBXML valueOfAttributeNamed:@"idref" forElement:itemref];
        [array addObject:idref];
        itemref = itemref->nextSibling;
    }
    self.bookspine = [NSArray arrayWithArray:array];
    
    NSString *tocid = [TBXML valueOfAttributeNamed:@"toc" forElement:spine];
    return [self.bookpath stringByAppendingPathComponent:[NSString stringWithFormat:@"OEBPS/%@",self.chapterFileDict[tocid]]];
}

- (void) parseTocNcx {
    //NSLog(@"----parse toc ncx-----");
    NSString *tocpath = [self parseContentOpf];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:tocpath]) {
        NSLog(@"toc file:%@ not exists", tocpath);
    }
    
    NSString *tocString = [NSString stringWithContentsOfFile:tocpath encoding:NSUTF8StringEncoding error:nil];
    TBXML *tocxml = [TBXML tbxmlWithXMLString:tocString error:nil];
    //NSLog(@"toc ncx content:%@", tocString);

    TBXMLElement *navmap = [TBXML childElementNamed:@"ncx:navMap" parentElement:tocxml.rootXMLElement];
    TBXMLElement *navpoint = [TBXML childElementNamed:@"ncx:navPoint" parentElement:navmap];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    while (navpoint) {
        NSString *tocid = [TBXML valueOfAttributeNamed:@"id" forElement:navpoint];
        TBXMLElement *navLabel = navpoint->firstChild;
        TBXMLElement *text = navLabel->firstChild;
        NSString *title = [TBXML textForElement:text];
        [dict setObject:title forKey:tocid];
        navpoint = navpoint->nextSibling;
    }
    self.chapterTitleDict = [NSDictionary dictionaryWithDictionary:dict];
}

- (NSArray *)chapters {
    if (!_chapters) {
        [self parseTocNcx];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *tocid in self.bookspine) {
            if (self.chapterTitleDict[tocid] ) {
                [array addObject:tocid];
            }
        }

        if ([array count]) {
            _chapters = [NSArray arrayWithArray:array];
        } else {
            _chapters = [NSArray arrayWithArray:self.bookspine];
        }
    }
    return _chapters;
}

- (NSMutableArray *) bookmarks {
    if (!_bookmarks) {
        _bookmarks = [[NSMutableArray alloc] init];
    }
    return _bookmarks;
}

- (NSString *) titleForChapter:(NSString *) chapter {
    if ([self.chapterTitleDict count]) {
        return self.chapterTitleDict[chapter];
    } else {
        return self.name;
    }
}

- (NSString *) contentPathForChapter: (NSString *) chapter {
    if (self.chapterFileDict[chapter]) {
        return [self.bookpath stringByAppendingPathComponent:[NSString stringWithFormat:@"OEBPS/%@", self.chapterFileDict[chapter]]];
    }
    return nil;
}

@end
