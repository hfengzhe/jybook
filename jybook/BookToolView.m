//
//  BookToolView.m
//  jybook
//
//  Created by yilang on 15/3/24.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookToolView.h"
#import "BookSpineViewController.h"
#import "BookFontView.h"

@interface BookToolView ()
@property (nonatomic, strong) BookFontView *bookFontView;
@property (nonatomic, strong) UIButton *prevChapterBtn;
@property (nonatomic, strong) UIButton *nextChapterBtn;
@property (nonatomic, strong) UIButton *chapterListBtn;
@property (nonatomic, strong) UIButton *fontBtn;
@property (nonatomic, strong) UIButton *bookmarkBtn;
@end

@implementation BookToolView

- (void) setButton:(UIButton *)button Title:(NSString *)title Frame:(CGRect)frame Align:(NSString *)align {
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    if ([align isEqualToString:@"left"]) {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    } else if ([align isEqualToString:@"right"]) {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    } else {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    [button addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
}

- (UIButton *)prevChapterBtn {
    if (!_prevChapterBtn) {
        _prevChapterBtn = [[UIButton alloc] init];
        CGRect frame = CGRectMake(0, 0, 100, 40);
        [self setButton:_prevChapterBtn Title:@"上一章" Frame:frame Align:@"left"];
    }
    return _prevChapterBtn;
}

- (UIButton *)nextChapterBtn {
    if (!_nextChapterBtn) {
        _nextChapterBtn = [[UIButton alloc] init];
        CGRect frame = CGRectMake(self.frame.size.width - 100, 0, 100, 40);
        [self setButton:_nextChapterBtn Title:@"下一章" Frame:frame Align:@"right"];
    }
    return _nextChapterBtn;
}

- (void)setupProgress {
    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progress setFrame:CGRectMake(100, 20, self.frame.size.width - 200, 40)];
    [progress setProgress:0.5];
    [progress setProgressTintColor:[UIColor redColor]];
    [self addSubview:progress];
}

- (UIButton *)chapterListBtn {
    if (!_chapterListBtn) {
        _chapterListBtn = [[UIButton alloc] init];
        CGRect frame = CGRectMake(0, 40, 100, 40);
        [self setButton:_chapterListBtn Title:@"📚"  Frame:frame Align:@"left"];
    }
    return _chapterListBtn;
}

- (UIButton *)fontBtn {
    if (!_fontBtn) {
        _fontBtn = [[UIButton alloc] init];
        CGRect frame = CGRectMake(100, 40, self.frame.size.width - 200, 40);
        [self setButton:_fontBtn Title:@"Aa" Frame:frame Align:@"center"];
    }
    return _fontBtn;
}

- (UIButton *)bookmarkBtn {
    if (!_bookmarkBtn) {
        _bookmarkBtn = [[UIButton alloc] init];
        CGRect frame = CGRectMake(self.frame.size.width - 100, self.frame.size.height - 40, 100, 40);
        [self setButton:_bookmarkBtn Title:@"📑" Frame:frame Align:@"right"];
    }
    return _bookmarkBtn;
}

- (void)drawRect:(CGRect)rect {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self addSubview:self.prevChapterBtn];
    [self setupProgress];
    [self addSubview:self.nextChapterBtn];
    [self addSubview:self.chapterListBtn];
    [self addSubview:self.fontBtn];
    [self addSubview:self.bookmarkBtn];
    [self addObserver:self forKeyPath:@"hidden" options:0 context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"hidden"]) {
        NSLog(@"----observer hidden------%@", change);
    }
}

#pragma mark -Action

- (void)btnTouchUpInside: (id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        NSString *title = [btn currentTitle];
        if ([title isEqualToString:@"上一章"]) {
            self.pageViewController.jumpPage = self.pageViewController.startPage;
            [self.pageViewController switchToPrevChapter];
        } else if ([title isEqualToString:@"下一章"]) {
            self.pageViewController.jumpPage = self.pageViewController.startPage;
            [self.pageViewController switchToNextChapter];
        } else if ([title isEqualToString:@"Aa"]) {
            [self.pageViewController showBookFontView];
        } else if ([title isEqualToString:@"📚"]) {
            BookSpineViewController *bsvc = [[BookSpineViewController alloc] init];
            bsvc.bpvc = self.pageViewController;
            [self.pageViewController presentViewController:bsvc animated:YES completion:nil];
        } else if ([title isEqualToString:@"📑"]) {
            [self.pageViewController toggleBookmark];
        }
        [self.pageViewController hideBookToolView];
    }
}

- (void)btnTouchDown: (id)sender {
    NSLog(@"---touch down---");
}

@end