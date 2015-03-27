//
//  BookPageViewController.h
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookPageViewController : UIViewController <UIGestureRecognizerDelegate, UIWebViewDelegate>
@property (nonatomic, strong) Book *book;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic) NSUInteger chapterIndex;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger jumpPage;
@property (nonatomic, readonly) NSUInteger startPage;

- (void) hideBookToolView;
- (void) showBookFontView;

- (void)switchNightMode;

- (void)setPageBackground:(NSString *)color;

- (void) toggleBookmark;

- (BOOL) isCurrentPositionInBookmark;

- (BOOL) canSwitchToPrevChapter;
- (BOOL) canSwitchToNextChapter;

- (void) switchToChapter:(NSInteger) chapterIndex;
- (void) switchToPrevChapter;
- (void) switchToNextChapter;

@end
