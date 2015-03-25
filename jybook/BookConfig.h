//
//  BookConfig.h
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BookConfig : NSObject

@property (nonatomic) BOOL nightMode;
@property (nonatomic, strong) NSString *backgroundColor;
@property (nonatomic) NSUInteger fontSize;
@property (nonatomic) NSUInteger lineSpacing;
@property (nonatomic) CGFloat brightness;

- (NSArray *) getBookmarksForBook:(NSString *)bookname;
- (void) setBookmarks:(NSArray *)bookmarks ForBook:(NSString *)bookname;

@end
