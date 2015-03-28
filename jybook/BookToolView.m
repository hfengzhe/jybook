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
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 12, self.frame.size.width - 200, 16)];
    [slider setTintColor:[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.9]];
    [slider setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.4]];
    [slider setThumbImage:[BookToolView sliderCircle] forState:UIControlStateNormal];

    //[slider setValue:self.pageViewController.currentPage];
    //[slider setMinimumValue:self.pageViewController.startPage];
    //[slider setMaximumValue:self.pageViewController.webview.pageCount];
    
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:slider];
}

+ (UIImage *)sliderCircle {
    static UIImage *Circle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(16.0f, 16.0f), YES, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGRect bounds = CGRectMake(0, 0, 16, 16);
        CGPoint center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
        CGContextSaveGState(ctx);
        
        CGContextSetLineWidth(ctx, 2);
        CGContextSetRGBStrokeColor(ctx, 0.9, 0.1, 0.1, 1.0);
        CGContextAddArc(ctx, center.x, center.y, 7, 0.0, M_PI*2, YES);
        CGContextStrokePath(ctx);
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        
        CGContextRestoreGState(ctx);
        Circle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return Circle;
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

- (id)init {
    if (self == [super init]) {
        [self addObserver:self forKeyPath:@"hidden" options:0 context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"hidden"];
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
 
}

- (void)updateBtnStatus {
    if ([self.pageViewController canSwitchToPrevChapter]) {
        [self.prevChapterBtn setEnabled:YES];
        [self.prevChapterBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9] forState:UIControlStateNormal];
    } else {
        [self.prevChapterBtn setEnabled:NO];
        [self.prevChapterBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4] forState:UIControlStateNormal];
    }
    if ([self.pageViewController canSwitchToNextChapter]) {
        [self.nextChapterBtn setEnabled:YES];
        [self.nextChapterBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9] forState:UIControlStateNormal];
    } else {
        [self.nextChapterBtn setEnabled:NO];
        [self.nextChapterBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4] forState:UIControlStateNormal];
    }
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.pageViewController.book.chapters[self.pageViewController.chapterIndex], self.pageViewController.currentPage];
    if ([self.pageViewController.book.bookmarks containsObject:position]) {
        [self.bookmarkBtn setTitle:@"📕" forState:UIControlStateNormal];
    } else {
        [self.bookmarkBtn setTitle:@"📑" forState:UIControlStateNormal];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"hidden"]) {
        if ([object isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *) object;
            if (!view.hidden) {
                [self updateBtnStatus];
            }
        }
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
        } else if ([title isEqualToString:@"📕"]) {
            [self.pageViewController toggleBookmark]; 
        }
        [self.pageViewController hideBookToolView];
    }
}

- (void)btnTouchDown: (id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        btn.titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4];
    }
}

- (void)sliderValueChanged: (id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        [self.pageViewController showBookSliderInfoView];
    }
}

- (void)sliderDragUp: (id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)sender;
        NSLog(@"----slider drag up--------:%f", slider.value);
    }
}

@end