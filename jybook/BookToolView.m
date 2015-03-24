//
//  BookToolView.m
//  jybook
//
//  Created by yilang on 15/3/24.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookToolView.h"

@implementation BookToolView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIButton *prevChapterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [prevChapterBtn setTitle:@"prev" forState:UIControlStateNormal];
    
    UIButton *nextChapterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [nextChapterBtn setTitle:@"next" forState:UIControlStateNormal];
    
    UIButton *chapterListBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [chapterListBtn setTitle:@"list" forState:UIControlStateNormal];
    
    UIButton *bookmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [bookmarkBtn setTitle:@"bookmark" forState:UIControlStateNormal];
    
    [self addSubview:prevChapterBtn];
}


@end
