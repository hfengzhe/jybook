//
//  BookPageViewController.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookPageViewController.h"

@interface BookPageViewController ()
@property (nonatomic) BOOL nightMode;
@property (nonatomic, strong) UIBarButtonItem *nightmodeBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *bookmarkBarButtonItem;
@property (nonatomic) BOOL goLastFlag;

@end

@implementation BookPageViewController
@synthesize nightMode = _nightMode;
@synthesize goLastFlag = _goLastFlag;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
    [self.webview loadRequest:req];
    
    self.webview.paginationMode = UIWebPaginationModeLeftToRight;
    self.webview.paginationBreakingMode = UIWebPaginationBreakingModePage;
    self.webview.scrollView.pagingEnabled = YES;
    self.webview.scrollView.bounces = NO;
    self.webview.scrollView.showsHorizontalScrollIndicator = NO;
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.scrollView.delaysContentTouches = NO;
    
    self.webview.scrollView.delegate = self;
    self.webview.delegate = self;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.nightmodeBarButtonItem, self.bookmarkBarButtonItem, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchToPrevChapter {
    if (self.chapterIndex > 0) {
        self.webview.hidden = YES;
        self.chapterIndex = self.chapterIndex - 1;
        self.url = [NSURL fileURLWithPath:[self.book contentPathForChapter:self.book.chapters[self.chapterIndex]]];
        NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
        [self.webview loadRequest:req];
        self.webview.hidden = NO;
        self.goLastFlag = TRUE;
    }
}

- (void)switchToNextChapter {
    if (self.chapterIndex < [self.book.chapters count] - 1) {
        self.webview.hidden = YES;
        self.chapterIndex = self.chapterIndex + 1;
        self.url = [NSURL fileURLWithPath:[self.book contentPathForChapter:self.book.chapters[self.chapterIndex]]];
        NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
        [self.webview loadRequest:req];
        self.webview.hidden = NO;
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

- (void)jumpToPage:(NSUInteger) page {
    CGRect frame = self.webview.scrollView.frame;
    frame.origin.x = frame.size.width * (page - 1);
    frame.origin.y = 0;
    [self.webview.scrollView scrollRectToVisible:frame animated:NO];
    self.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.x > 0) {
        if (self.currentPage == self.startPage) {
            [self switchToPrevChapter];
        }
    } else {
        if (self.currentPage == self.webview.pageCount) {
            [self switchToNextChapter];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentPage = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    if ([self.book.bookmarks containsObject:position]) {
        [self.bookmarkBarButtonItem setTitle:@"📕"];
    } else {
        [self.bookmarkBarButtonItem setTitle:@"📑"];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self syncNightMode:self.nightMode];
    if (self.goLastFlag) {
        self.goLastFlag = FALSE;
        [self jumpToPage:self.webview.pageCount];
    } else if (self.jumpPage != self.currentPage) {
        [self jumpToPage:self.jumpPage];
    }
}

@end
