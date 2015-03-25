//
//  BookConfig.m
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookConfig.h"

@implementation BookConfig

- (NSArray *) getBookmarksForBook:(NSString *)bookname {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:[NSString stringWithFormat:@"bookmark->%@", bookname]];
}

- (void) setBookmarks:(NSArray *)bookmarks ForBook:(NSString *)bookname {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:bookmarks forKey:[NSString stringWithFormat:@"bookmark->%@", bookname]];
}


@end
