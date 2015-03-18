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

@end

@implementation BookPageViewController

- (UIBarButtonItem *) nightmodeBarButtonItem {
    if (!_nightmodeBarButtonItem) {
        _nightmodeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"🌙" style:UIBarButtonItemStyleDone target:self action:@selector(switchNightMode)];
    }
    return _nightmodeBarButtonItem;
}

- (UIBarButtonItem *) bookmarkBarButtonItem {
    if (!_bookmarkBarButtonItem) {
        _bookmarkBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"📑" style:UIBarButtonItemStyleDone target:self action:@selector(toggleBookmark)];
    }
    return _bookmarkBarButtonItem;
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
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.nightmodeBarButtonItem, self.bookmarkBarButtonItem, nil];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated  {
    NSUInteger page = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;
    if (page != self.currentPage) {
        self.webview.hidden = YES;
        [self jumpToPage:self.currentPage];
    }
}

- (void)switchToPrevChapter {
    if (self.chapterIndex > 0) {
        self.webview.hidden = YES;
        self.chapterIndex = self.chapterIndex - 1;
        self.url = [NSURL fileURLWithPath:[self.book contentPathForChapter:self.book.chapters[self.chapterIndex]]];
        NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
        [self.webview loadRequest:req];
        self.webview.hidden = NO;
    }
}

- (void)switchToNextChapter {
    if (self.chapterIndex < [self.book.chapters count] - 1) {
        self.webview.hidden = YES;
        self.chapterIndex = self.chapterIndex + 1;
        self.url = [NSURL fileURLWithPath:[self.book contentPathForChapter:self.book.chapters[self.chapterIndex]]];
        NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
        [self.webview loadRequest:req];
        self.webview.hidden = NO;    }
}

- (void)switchNightMode {
    if (self.nightMode) {
        self.nightMode = FALSE;
        NSString *str = @"document.body.style.background='#FFFFFF';document.body.style.color='#000000'";
        [self.webview stringByEvaluatingJavaScriptFromString:str];
        [self.nightmodeBarButtonItem setTitle:@"🌙"];
    } else {
        self.nightMode = TRUE;
        NSString *str = @"document.body.style.background='#080c10';document.body.style.color='#424952'";
        [self.webview stringByEvaluatingJavaScriptFromString:str];
        [self.nightmodeBarButtonItem setTitle:@"☀️"];
    }

}

- (void)toggleBookmark {
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    if ([self.book.bookmarks containsObject:position]) {
        [self.book.bookmarks removeObject:position];
        [self.bookmarkBarButtonItem setTitle:@"📕"];
    } else {
        [self.book.bookmarks addObject:position];
        [self.bookmarkBarButtonItem setTitle:@"📑"];
    }
}

- (void)jumpToPage:(NSUInteger) page {
    CGFloat offset = page * self.webview.scrollView.frame.size.width;
    //NSLog(@"offset:%f", offset);
    NSString *pageScrollFunc = [NSString stringWithFormat:@"function pageScroll(xoffset) {window.scroll(xoffset, 0);}"];
    NSString *jump = [NSString stringWithFormat:@"pageScroll(%f)", offset];
    
    [self.webview stringByEvaluatingJavaScriptFromString:pageScrollFunc];
    [self.webview stringByEvaluatingJavaScriptFromString:jump];
    self.webview.hidden = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.x > 0) {
        if (self.currentPage == 1) {
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
}


@end
