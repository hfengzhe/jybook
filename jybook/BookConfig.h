//
//  BookConfig.h
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookConfig : NSObject

- (NSArray *) getBookmarksForBook:(NSString *)bookname;
- (void) setBookmarks:(NSArray *)bookmarks ForBook:(NSString *)bookname;

@end
