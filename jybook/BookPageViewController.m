//
//  BookPageViewController.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookPageViewController.h"

@interface BookPageViewController ()

@end

@implementation BookPageViewController

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
    self.webview.scrollView.delegate = self;
    
    UIBarButtonItem *nextBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"▶︎" style:UIBarButtonItemStyleDone target:self action:@selector(switchToNextPage)];
    
    UIBarButtonItem *prevBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"◀︎" style:UIBarButtonItemStyleDone target:self action:@selector(switchToPrevPage)];
    
    UIBarButtonItem *nightmodeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"🌙" style:UIBarButtonItemStyleDone target:self action:@selector(switchNightMode)];
    
    UIBarButtonItem *bookmarkBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"📗" style:UIBarButtonItemStyleDone target:self action:@selector(toggleBookmark)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nextBarButtonItem, prevBarButtonItem, nightmodeBarButtonItem, bookmarkBarButtonItem, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchToNextPage {
    NSLog(@"----switch to next page-------");
}

- (void)switchToPrevPage {
    NSLog(@"----switch to prev page--------");
}

- (void)switchNightMode {
    NSLog(@"----switch night mode-----");
}

- (void)toggleBookmark {
    NSString *position = [NSString stringWithFormat:@"%@:%lul", self.book.chapters[self.chapterIndex], self.currentPage];
    if ([self.book.bookmarks containsObject:position]) {
        [self.book.bookmarks removeObject:position];
    } else {
        [self.book.bookmarks addObject:position];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentPage = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;

}


@end
