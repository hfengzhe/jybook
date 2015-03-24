//
//  BookPageViewController.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookPageViewController.h"
#import "BookToolView.h"

@interface BookPageViewController ()
@property (nonatomic) BOOL nightMode;
@property (nonatomic, strong) UIBarButtonItem *nightmodeBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *bookmarkBarButtonItem;
@property (nonatomic, strong) BookToolView  *bookToolView;
@property (nonatomic) BOOL goLastFlag;
@property (nonatomic) BOOL showToolView;

@end

@implementation BookPageViewController
@synthesize nightMode = _nightMode;
@synthesize goLastFlag = _goLastFlag;

#pragma mark - Getter/Setter

- (BOOL)nightMode {
    if (!_nightMode) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _nightMode = [user boolForKey:@"nightMode"];
    }
    return _nightMode;
}

- (void)setNightMode:(BOOL)nightMode {
    _nightMode = nightMode;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:nightMode forKey:@"nightMode"];
}

- (UIBarButtonItem *)nightmodeBarButtonItem {
    if (!_nightmodeBarButtonItem) {
        _nightmodeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"🌙" style:UIBarButtonItemStyleDone target:self action:@selector(switchNightMode)];
    }
    return _nightmodeBarButtonItem;
}

- (UIBarButtonItem *)bookmarkBarButtonItem {
    if (!_bookmarkBarButtonItem) {
        _bookmarkBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"📑" style:UIBarButtonItemStyleDone target:self action:@selector(toggleBookmark)];
    }
    return _bookmarkBarButtonItem;
}

- (BookToolView *)bookToolView {
    if (!_bookToolView) {
        _bookToolView  = [[BookToolView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80)];
        [self.view insertSubview:_bookToolView aboveSubview:self.webview];
        [_bookToolView setHidden:YES];
        self.showToolView = NO;
        _bookToolView.pageViewController = self;
        _bookToolView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }
    return _bookToolView;
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

    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
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
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.nightmodeBarButtonItem, self.bookmarkBarButtonItem, nil];
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
    [self syncNightMode:self.nightMode];
    if (self.goLastFlag) {
        self.goLastFlag = FALSE;
        [self jumpToPage:self.webview.pageCount];
    } else if (self.jumpPage != self.currentPage) {
        [self jumpToPage:self.jumpPage];
    }
    [self updatePageBookmarkStatus];
}

- (BOOL)prefersStatusBarHidden {
    if (self.showToolView) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isCurrentPositionInBookmark {
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    return [self.book.bookmarks containsObject:position];
}

- (void)updatePageBookmarkStatus {
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    if ([self.book.bookmarks containsObject:position]) {
        [self.bookmarkBarButtonItem setTitle:@"📕"];
    } else {
        [self.bookmarkBarButtonItem setTitle:@"📑"];
    }
}

- (void)syncNightMode:(BOOL) nightMode {
    if (nightMode) {
        NSString *str = @"document.body.style.background='#080c10';document.body.style.color='#424952'";
        [self.webview stringByEvaluatingJavaScriptFromString:str];
        [self.nightmodeBarButtonItem setTitle:@"☀️"];
    } else {
        NSString *str = @"document.body.style.background='#FFFFFF';document.body.style.color='#000000'";
        [self.webview stringByEvaluatingJavaScriptFromString:str];
        [self.nightmodeBarButtonItem setTitle:@"🌙"];
    }
}

- (void)switchNightMode {
    self.nightMode = ! self.nightMode;
    [self syncNightMode:self.nightMode];
}

- (void)toggleBookmark {
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    if ([self.book.bookmarks containsObject:position]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.book.bookmarks];
        [array removeObject:position];
        [self.book setBookmarks:array];
        [self.bookmarkBarButtonItem setTitle:@"📑"];
    } else {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.book.bookmarks];
        [array addObject:position];
        [self.book setBookmarks:array];
        [self.bookmarkBarButtonItem setTitle:@"📕"];
    }
}

#pragma mark - Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self hideBookToolView];
    self.currentPage = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;
    if (self.currentPage == self.startPage) {
        [self switchToPrevChapter];
        self.goLastFlag = TRUE;
    } else {
        [self jumpToPage:self.currentPage - 1];
    }
    [self updatePageBookmarkStatus];
    if ((self.chapterIndex == 0) && (self.currentPage == self.startPage)) {
        NSLog(@"You are in first page already");
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
    self.currentPage = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;
    if (self.currentPage == self.webview.pageCount) {
        [self switchToNextChapter];
        self.jumpPage = self.startPage;
    } else {
        [self jumpToPage:self.currentPage + 1];
    }
    [self updatePageBookmarkStatus];
    if ((self.chapterIndex == [self.book.chapters count] - 1) && (self.currentPage = self.webview.pageCount)) {
        NSLog(@"You are in last page already");
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

- (void)hideBookToolView {
    [self.bookToolView setHidden:TRUE];
    self.showToolView = FALSE;
    [self.navigationController setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showBookToolView {
    [self.bookToolView setHidden:NO];
    self.showToolView = TRUE;
    [self.navigationController setNavigationBarHidden:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)tapPage:(UITapGestureRecognizer *)recognizer {
    if (!self.showToolView) {
        [self showBookToolView];
    } else {
        [self hideBookToolView];
    }
}

#pragma mark - Switch Page

- (BOOL)canSwitchToPrevChapter {
    return self.chapterIndex > 0;
}

- (BOOL) canSwitchToNextChapter {
    return self.chapterIndex < [self.book.chapters count] - 1;
}

- (void)switchToPrevChapter {
    if (![self canSwitchToPrevChapter]) {
        return;
    }
    self.webview.hidden = YES;
    self.chapterIndex = self.chapterIndex - 1;
    self.url = [NSURL fileURLWithPath:[self.book contentPathForChapter:self.book.chapters[self.chapterIndex]]];
    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
    [self.webview loadRequest:req];
    self.webview.hidden = NO;
}

- (void)switchToNextChapter {
    if (![self canSwitchToNextChapter]) {
        return;
    }
    self.webview.hidden = YES;
    self.chapterIndex = self.chapterIndex + 1;
    self.url = [NSURL fileURLWithPath:[self.book contentPathForChapter:self.book.chapters[self.chapterIndex]]];
    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
    [self.webview loadRequest:req];
    self.webview.hidden = NO;
}

- (void)jumpToPage:(NSUInteger) page {
    CGRect frame = self.webview.scrollView.frame;
    frame.origin.x = frame.size.width * (page - 1);
    frame.origin.y = 0;
    [self.webview.scrollView scrollRectToVisible:frame animated:NO];
    self.currentPage = page;
}

@end
