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
@end

@implementation Book

- (id) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.epubpath = [[NSBundle mainBundle] pathForResource:self.name ofType:@"epub" inDirectory:@"epub"];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.bookpath = [documentPath stringByAppendingPathComponent:self.name];
        
        self.catalog = [NSArray arrayWithObjects:@"first chapter",@"second chapter", @"third chapter",@"fourth chapter", @"fifth chapter", @"six chapter", @"seven chapter", @"eight chatper", @"nine chapter", @"ten chapter", @"eleven chapter", @"twenty two chapter", @"theraf chapter", @"mamafasfd chapter", @"adfafa chapter", @"afsaf chapter", @"sfsdafsfd chapter", nil];
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
    if (root) {
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
    }
    return nil;
}

- (void)parseContentOpf {
    NSString *opfpath = [self getOpfFilePathByParseMetaXml];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:opfpath]) {
        NSLog(@"content opf file:%@ not exists", opfpath);
    }
    NSLog(@"opf path:%@", opfpath);
}

- (NSArray *)catalog {
    if (_catalog == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
    }
    return _catalog;
}

@end
