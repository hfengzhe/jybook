//
//  Book.h
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *catalog;
@property (nonatomic, strong) NSDictionary *contents;

- (id) initWithName:(NSString *)name;
@end
