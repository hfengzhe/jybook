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
@property (nonatomic, strong) NSDictionary *bookcatalog;
@property (nonatomic, strong) NSArray *bookspine;
@end

@implementation Book

- (id) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.epubpath = [[NSBundle mainBundle] pathForResource:self.name ofType:@"epub" inDirectory:@"epub"];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.bookpath = [documentPath stringByAppendingPathComponent:self.name];
    
        self.contents = nil;
        [self parseContentOpf];
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

- (NSString *) getOpfFilePathByParseMetaXml {
    NSString *metapath = [self.bookpath stringByAppendingPathComponent:@"META-INF/container.xml"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:metapath]) {
        [self unzipBook];
    }

    NSString *metaString = [NSString stringWithContentsOfFile:metapath encoding:NSUTF8StringEncoding error:nil];
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

- (void)parseContentOpf {
    NSString *opfpath = [self getOpfFilePathByParseMetaXml];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:opfpath]) {
        NSLog(@"content opf file:%@ not exists", opfpath);
    }
    NSString *content = [NSString stringWithContentsOfFile:opfpath encoding:NSUTF8StringEncoding error:nil];
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
    self.bookcatalog = [NSDictionary dictionaryWithDictionary:dict];
    
    TBXMLElement *spine = [TBXML childElementNamed:@"spine" parentElement:contentxml.rootXMLElement];
    TBXMLElement *itemref = spine->firstChild;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while (itemref) {
        NSString *idref = [TBXML valueOfAttributeNamed:@"idref" forElement:itemref];
        [array addObject:idref];
        itemref = itemref->nextSibling;
    }
    self.bookspine = [NSArray arrayWithArray:array];
}

- (NSArray *)chapters {
    return self.bookspine;
}

@end
