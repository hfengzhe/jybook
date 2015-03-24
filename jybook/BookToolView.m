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
    [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    
    UIButton *prevChapterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [prevChapterBtn setTitle:@"上一章" forState:UIControlStateNormal];
    [prevChapterBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [prevChapterBtn  setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [prevChapterBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [prevChapterBtn addTarget:self action:@selector(prevChapterClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progress setFrame:CGRectMake(100, 20, self.frame.size.width - 200, 40)];
    [progress setProgress:0.5];
    [progress setProgressTintColor:[UIColor redColor]];
    
    
    UIButton *nextChapterBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 0, 100, 40)];
    [nextChapterBtn setTitle:@"下一章" forState:UIControlStateNormal];
    [nextChapterBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [nextChapterBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [nextChapterBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [nextChapterBtn addTarget:self action:@selector(nextChapterClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chapterListBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 100, 40)];
    [chapterListBtn setTitle:@"📚" forState:UIControlStateNormal];
    [chapterListBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [chapterListBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [chapterListBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [chapterListBtn addTarget:self action:@selector(chapterListClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fontBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 40, self.frame.size.width - 200, 40)];
    [fontBtn setTitle:@"A" forState:UIControlStateNormal];
    [fontBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [fontBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [fontBtn addTarget:self action:@selector(fontClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bookmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, self.frame.size.height - 40, 100, 40)];
    [bookmarkBtn setTitle:@"📑" forState:UIControlStateNormal];
    [bookmarkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [bookmarkBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [bookmarkBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [bookmarkBtn addTarget:self action:@selector(bookmarkClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:prevChapterBtn];
    [self addSubview:progress];
    [self addSubview:nextChapterBtn];
    
    [self addSubview:chapterListBtn];
    [self addSubview:fontBtn];
    [self addSubview:bookmarkBtn];
}

- (void) prevChapterClick: (id)sender {
    [self.pageViewController toggleShowBookToolView];
    self.pageViewController.jumpPage = self.pageViewController.startPage;
    [self.pageViewController switchToPrevChapter];
}

- (void) nextChapterClick: (id)sender {
    [self.pageViewController toggleShowBookToolView];
    self.pageViewController.jumpPage = self.pageViewController.startPage;
    [self.pageViewController switchToNextChapter];
}

- (void) chapterListClick: (id)sender {
    [self.pageViewController toggleShowBookToolView];
}

- (void) fontClick: (id)sender {
    [self.pageViewController toggleShowBookToolView];
}

- (void) bookmarkClick: (id)sender {
    [self.pageViewController toggleShowBookToolView];
}


@end
