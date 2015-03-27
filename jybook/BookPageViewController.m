//
//  BookPageViewController.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookPageViewController.h"
#import "BookToolView.h"
#import "BookFontView.h"
#import "BookConfig.h"

@interface BookPageViewController ()
@property (nonatomic, strong) BookToolView *bookToolView;
@property (nonatomic, strong) BookFontView *bookFontView;
@property (nonatomic, strong) BookConfig *bookconfig;

@property (nonatomic) BOOL goLastFlag;

@end

@implementation BookPageViewController
@synthesize goLastFlag = _goLastFlag;

#pragma mark - Getter/Setter

- (BookToolView *)bookToolView {
    if (!_bookToolView) {
        _bookToolView  = [[BookToolView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80)];
        [self.view insertSubview:_bookToolView aboveSubview:self.webview];
        [_bookToolView setHidden:YES];
        _bookToolView.pageViewController = self;
        _bookToolView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
    }
    return _bookToolView;
}

- (BookFontView *)bookFontView {
    if (!_bookFontView) {
        _bookFontView  = [[BookFontView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
        [self.view insertSubview:_bookFontView aboveSubview:self.webview];
        [_bookFontView setHidden:YES];
        _bookFontView.pageViewController = self;
        _bookFontView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
    }
    return _bookFontView;
}

- (void)hideBookToolView {
    [self.bookToolView setHidden:TRUE];
    [self.navigationController setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showBookToolView {
    [self.bookToolView setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showBookFontView {
    [self.bookFontView setHidden:NO];
}

- (void)hideBookFontView {
    [self.bookFontView setHidden:YES];
}

- (BOOL)goLastFlag {
    if (!_goLastFlag) {
        _goLastFlag = FALSE;
    }
    return _goLastFlag;
}

- (void)setGoLastFlag:(BOOL)goLastFlag {
    _goLastFlag = goLastFlag;
}

- (NSUInteger)startPage {
    return 2;
}

- (NSUInteger) jumpPage {
    if (!_jumpPage) {
        _jumpPage = 1;
    }
    return _jumpPage;
}

#pragma mark -View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bookconfig = [BookConfig sharedConfig];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSURL *url = [NSURL fileURLWithPath:[self.book contentPathForChapter:self.book.chapters[self.chapterIndex]]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:req];
    
    self.webview.paginationMode = UIWebPaginationModeLeftToRight;
    self.webview.paginationBreakingMode = UIWebPaginationBreakingModePage;
    self.webview.scrollView.bounces = NO;
    self.webview.scrollView.scrollEnabled = NO;
    self.webview.delegate = self;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPage:)];
    tap.delegate = self;
    
    [self.webview addGestureRecognizer:tap];
    [self.webview addGestureRecognizer:swipeLeft];
    [self.webview addGestureRecognizer:swipeRight];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self syncNightMode:self.bookconfig.nightMode];
    if (self.goLastFlag) {
        self.goLastFlag = FALSE;
        [self jumpToPage:self.webview.pageCount];
    } else if (self.jumpPage != self.currentPage) {
        [self jumpToPage:self.jumpPage];
    }
}

- (BOOL)prefersStatusBarHidden {
    return [self.bookToolView isHidden];
}

- (BOOL)isCurrentPositionInBookmark {
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    return [self.book.bookmarks containsObject:position];
}

- (void)syncNightMode:(BOOL) nightMode {
    if (nightMode) {
        NSString *str = @"document.body.style.background='#080c10';document.body.style.color='#424952'";
        [self.webview stringByEvaluatingJavaScriptFromString:str];
    } else {
        NSString *str = @"document.body.style.background='#FFFFFF';document.body.style.color='#000000'";
        [self.webview stringByEvaluatingJavaScriptFromString:str];
    }
}

- (void)switchNightMode {
    self.bookconfig.nightMode = ! self.bookconfig.nightMode;
    [self syncNightMode:self.bookconfig.nightMode];
}

- (void)toggleBookmark {
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    if ([self.book.bookmarks containsObject:position]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.book.bookmarks];
        [array removeObject:position];
        [self.book setBookmarks:array];
    } else {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.book.bookmarks];
        [array addObject:position];
        [self.book setBookmarks:array];
    }
}

#pragma mark - Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void) switchShowTip:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 60, self.view.frame.size.height / 2 - 20, 120, 40)];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9]];
    [label setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [[label layer] setCornerRadius:8.0f];
    [[label layer] setMasksToBounds:YES];
    [self.view insertSubview:label aboveSubview:self.webview];
    
    [UIView animateWithDuration:1.0f delay:0.8f options:UIViewAnimationOptionCurveLinear animations:^{
        label.alpha = 0.0;
    }completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self hideBookToolView];
    [self hideBookFontView];
    self.currentPage = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;
    if (self.currentPage == self.startPage) {
        [self switchToPrevChapter];
        self.goLastFlag = TRUE;
    } else {
        [self jumpToPage:self.currentPage - 1];
    }
    if ((self.chapterIndex == 0) && (self.currentPage == self.startPage)) {
        [self switchShowTip:@"已到第一页"];
   
    } else {
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setDuration:1.0f];
        [animation setStartProgress:0.5];
        [animation setEndProgress:1.0];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:@"pageCurl"];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setRemovedOnCompletion:NO];
        [animation setFillMode:@"extended"];
        [[self.webview layer] addAnimation:animation forKey:@"turnPage"];
    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    [self hideBookToolView];
    [self hideBookFontView];
    self.currentPage = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;
    if (self.currentPage == self.webview.pageCount) {
        [self switchToNextChapter];
        self.jumpPage = self.startPage;
        self.currentPage = self.jumpPage;
    } else {
        [self jumpToPage:self.currentPage + 1];
    }
    if ((self.chapterIndex == [self.book.chapters count] - 1) && (self.currentPage == self.webview.pageCount)) {
        [self switchShowTip:@"已到最后一页"];
    } else {
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setDuration:1.0f];
        [animation setStartProgress:0.5];
        [animation setEndProgress:1.0];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:@"pageCurl"];
        [animation setSubtype:kCATransitionFromRight];
        [animation setRemovedOnCompletion:NO];
        [animation setFillMode:@"extended"];
        [[self.webview layer] addAnimation:animation forKey:@"turnPage"];
    }
}

- (void)tapPage:(UITapGestureRecognizer *)recognizer {
    if ([self.bookToolView isHidden] && [self.bookFontView isHidden]) {
        [self showBookToolView];
    } else {
        [self hideBookToolView];
        [self hideBookFontView];
    }
}

#pragma mark - Switch Page

- (BOOL)canSwitchToPrevChapter {
    return self.chapterIndex > 0;
}

- (BOOL) canSwitchToNextChapter {
    return self.chapterIndex < [self.book.chapters count] - 1;
}

- (void)switchToChapter:(NSInteger) chapterIndex {
    self.webview.hidden = YES;
    self.chapterIndex = chapterIndex;
    NSURL *url = [NSURL fileURLWithPath:[self.book contentPathForChapter:self.book.chapters[self.chapterIndex]]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:req];
    self.webview.hidden = NO;
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    [self.bookconfig setLastPosition:position ForBook:self.book.name];
}

- (void)switchToPrevChapter {
    if (![self canSwitchToPrevChapter]) {
        return;
    }
    [self switchToChapter:self.chapterIndex - 1];
}

- (void)switchToNextChapter {
    if (![self canSwitchToNextChapter]) {
        return;
    }
    [self switchToChapter:self.chapterIndex + 1];
}

- (void)jumpToPage:(NSUInteger) page {
    CGRect frame = self.webview.scrollView.frame;
    frame.origin.x = frame.size.width * (page - 1);
    frame.origin.y = 0;
    [self.webview.scrollView scrollRectToVisible:frame animated:NO];
    self.currentPage = page;
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    [self.bookconfig setLastPosition:position ForBook:self.book.name];
}

@end
