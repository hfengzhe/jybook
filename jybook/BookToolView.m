//
//  BookToolView.m
//  jybook
//
//  Created by yilang on 15/3/24.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookToolView.h"
#import "BookSpineViewController.h"

@implementation BookToolView

- (void)setupPrevChapterBtn {
    UIButton *prevChapterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [prevChapterBtn setTitle:@"上一章" forState:UIControlStateNormal];
    [prevChapterBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [prevChapterBtn  setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [prevChapterBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [prevChapterBtn addTarget:self action:@selector(prevChapterClick:) forControlEvents:UIControlEventTouchUpInside];
    if (![self.pageViewController canSwitchToPrevChapter]) {
        [prevChapterBtn setEnabled:NO];
        [prevChapterBtn setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]];
    } else {
        [prevChapterBtn setEnabled:YES];
    }
    [self addSubview:prevChapterBtn];
}

- (void)setupProgress {
    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progress setFrame:CGRectMake(100, 20, self.frame.size.width - 200, 40)];
    [progress setProgress:0.5];
    [progress setProgressTintColor:[UIColor redColor]];
    [self addSubview:progress];
}

- (void)setupNextChapterBtn {
    UIButton *nextChapterBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 0, 100, 40)];
    [nextChapterBtn setTitle:@"下一章" forState:UIControlStateNormal];
    [nextChapterBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [nextChapterBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [nextChapterBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [nextChapterBtn addTarget:self action:@selector(nextChapterClick:) forControlEvents:UIControlEventTouchUpInside];
    if (![self.pageViewController canSwitchToNextChapter]) {
        [nextChapterBtn setEnabled:NO];
        [nextChapterBtn setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]];
    } else {
        [nextChapterBtn setEnabled:YES];
    }
    [self addSubview:nextChapterBtn];
}

- (void)setupChapterListBtn {
    UIButton *chapterListBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 100, 40)];
    [chapterListBtn setTitle:@"📚" forState:UIControlStateNormal];
    [chapterListBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [chapterListBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [chapterListBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [chapterListBtn addTarget:self action:@selector(chapterListClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chapterListBtn];
}

- (void)setupFontBtn {
    UIButton *fontBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 40, self.frame.size.width - 200, 40)];
    [fontBtn setTitle:@"A" forState:UIControlStateNormal];
    [fontBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [fontBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [fontBtn addTarget:self action:@selector(fontClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fontBtn];
}

- (void)setupBookmarkBtn {
    UIButton *bookmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, self.frame.size.height - 40, 100, 40)];
    [bookmarkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [bookmarkBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [bookmarkBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [bookmarkBtn addTarget:self action:@selector(bookmarkClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.pageViewController isCurrentPositionInBookmark]) {
        [bookmarkBtn setTitle:@"📕" forState:UIControlStateNormal];
    } else {
        [bookmarkBtn setTitle:@"📑" forState:UIControlStateNormal];
    }
    [self addSubview:bookmarkBtn];
}


- (void)drawRect:(CGRect)rect {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setupPrevChapterBtn];
    [self setupProgress];
    [self setupNextChapterBtn];
    
    [self setupChapterListBtn];
    [self setupFontBtn];
    [self setupBookmarkBtn];
}

- (void) prevChapterClick: (id)sender {
    [self.pageViewController hideBookToolView];
    self.pageViewController.jumpPage = self.pageViewController.startPage;
    [self.pageViewController switchToPrevChapter];
}

- (void) nextChapterClick: (id)sender {
    [self.pageViewController hideBookToolView];
    self.pageViewController.jumpPage = self.pageViewController.startPage;
    [self.pageViewController switchToNextChapter];
}

- (void) chapterListClick: (id)sender {
    BookSpineViewController *bsvc = [[BookSpineViewController alloc] init];
    bsvc.bpvc = self.pageViewController;
    [self.pageViewController presentViewController:bsvc animated:YES completion:nil];
    [self.pageViewController hideBookToolView];
}

- (void) fontClick: (id)sender {
    [self.pageViewController hideBookToolView];
}

- (void) bookmarkClick: (id)sender {
    [self.pageViewController hideBookToolView];
    [self.pageViewController toggleBookmark];
}


@end
