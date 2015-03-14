//
//  Book.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "Book.h"

@implementation Book

- (id) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.img = name;
        self.catalog = [NSArray arrayWithObjects:@"first chapter",@"second chapter", @"third chapter",@"fourth chapter", @"fifth chapter", @"six chapter", @"seven chapter", @"eight chatper", @"nine chapter", @"ten chapter", @"eleven chapter", @"twenty two chapter", @"theraf chapter", @"mamafasfd chapter", @"adfafa chapter", @"afsaf chapter", @"sfsdafsfd chapter", nil];
        self.contents = nil;
    }
    return self;
}
@end
