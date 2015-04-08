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
#import "BookSliderInfoView.h"
#import "BookConfig.h"

@interface BookPageViewController ()
@property (nonatomic, strong) BookToolView *bookToolView;
@property (nonatomic, strong) BookFontView *bookFontView;
@property (nonatomic, strong) BookSliderInfoView *bookSliderInfoView;
@property (nonatomic, strong) BookConfig *bookconfig;


@property (nonatomic) NSUInteger currentPage;
@end

#define MAX_FONT_SIZE   200
#define MIN_FONT_SIZE   50

@implementation BookPageViewController

#pragma mark -Sub view getter

- (BookToolView *)bookToolView {
    if (!_bookToolView) {
        _bookToolView  = [[BookToolView alloc] init];
        [_bookToolView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 80)];
        [self.view insertSubview:_bookToolView aboveSubview:self.webview];
        [_bookToolView setHidden:YES];
        _bookToolView.pageViewController = self;
        _bookToolView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
    }
    return _bookToolView;
}

- (BookFontView *)bookFontView {
    if (!_bookFontView) {
        _bookFontView  = [[BookFontView alloc] init];
        [_bookFontView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        [self.view insertSubview:_bookFontView aboveSubview:self.webview];
        [_bookFontView setHidden:YES];
        _bookFontView.pageViewController = self;
        _bookFontView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
    }
    return _bookFontView;
}

- (BookSliderInfoView *)bookSliderInfoView {
    if (!_bookSliderInfoView) {
        _bookSliderInfoView = [[BookSliderInfoView alloc] init];
        [_bookSliderInfoView setFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height - 200, 200, 100)];
        [[_bookSliderInfoView layer] setCornerRadius:16.0f];
        [[_bookSliderInfoView layer] setMasksToBounds:TRUE];
        
        [self.view insertSubview:_bookSliderInfoView aboveSubview:self.webview];
        [_bookSliderInfoView setHidden:YES];
        _bookSliderInfoView.pageViewController = self;
        _bookSliderInfoView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
    }
    return _bookSliderInfoView;
}

#pragma mark -Sub view show/hide

- (void)hideBookToolView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.bookToolView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 80)];
    } completion:^(BOOL finished) {
        [self.bookToolView setHidden:TRUE];
        [self.navigationController setNavigationBarHidden:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    [self.bookSliderInfoView setHidden:TRUE];
}

- (void)showBookToolView {
    [self.bookToolView setHidden:NO];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
         [self.bookToolView setFrame:CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80)];
    } completion:^(BOOL finished) {}];
    [self.navigationController setNavigationBarHidden:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showBookFontView {
    [self.bookToolView setHidden:YES];
    [self.bookFontView setHidden:NO];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.bookFontView setFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
    } completion:^(BOOL finished) {}];
}

- (void)hideBookFontView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.bookFontView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    } completion:^(BOOL finished) {
        [self.bookFontView setHidden:TRUE];
    }];
}

- (void)showBookSliderInfoView:(NSString *)progress {
    [self.bookSliderInfoView.titleLabel setText:[NSString stringWithFormat:@"%@\n%@", [self.book titleForChapter:self.book.chapters[self.chapterIndex]], progress]];
    [self.bookSliderInfoView setHidden:NO];
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
        CGContextClearRect(ctx, bounds);
        
        CGContextSetLineWidth(ctx, 2);
        CGContextSetRGBStrokeColor(ctx, 0.9, 0.1, 0.1, 1.0);
        CGContextAddArc(ctx, center.x, center.y, 7, 0.0, M_PI*2, YES);
        CGContextStrokePath(ctx);
        
        CGContextRestoreGState(ctx);
        Circle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return Circle;
}

#pragma mark -Getter/Setter

- (NSUInteger)startPage {
    return 2;
}

#pragma mark -View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bookconfig = [BookConfig sharedConfig];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
    
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
    [[UIScreen mainScreen] setBrightness:self.bookconfig.brightness];
    [self setPageFontSize:self.bookconfig.fontSize];
    if (self.progress) {
        NSArray *array = [self.progress componentsSeparatedByString:@"/"];
        if ([array count] == 2) {
            NSString *page = [array objectAtIndex:0];
            NSString *total = [array objectAtIndex:1];
            if ([page isEqualToString:total]) {
                [self jumpToPage:[self.webview pageCount]];
            } else {
                NSUInteger jump = (page.integerValue - self.startPage) * ([self.webview pageCount] - self.startPage)/ (total.integerValue - self.startPage) + self.startPage + 0.5 ;
                [self jumpToPage:jump];
            }
        }
    } else {
        [self jumpToPage:self.startPage];
    }
}

- (BOOL)prefersStatusBarHidden {
    return [self.bookToolView isHidden];
}

#pragma mark -Line spacing
- (void)setLineHeight:(NSUInteger) lineHeight {
    NSString *str = nil;
    if (lineHeight == 3) {
        str = @"document.body.style.lineHeight='2';";
    } else if (lineHeight == 2) {
        str = @"document.body.style.lineHeight='1.5';";
    } else {
        str = @"document.body.style.lineHeight='1';";
    }
    [self.webview stringByEvaluatingJavaScriptFromString:str];
}

#pragma mark -Font size

- (BOOL)canIncreaseFontSize {
    return self.bookconfig.fontSize < MAX_FONT_SIZE;
}

- (BOOL)canDecreaseFontSize {
    return self.bookconfig.fontSize > MIN_FONT_SIZE;
}

- (void) increaseFontSize {
    self.progress = [NSString stringWithFormat:@"%lu/%lu", self.currentPage, [self.webview pageCount]];
    if ([self canIncreaseFontSize]) {
        self.bookconfig.fontSize = self.bookconfig.fontSize + 20;
        [self setPageFontSize:self.bookconfig.fontSize];
    }
}

- (void) decreaseFontSize {
    self.progress = [NSString stringWithFormat:@"%lu/%lu", self.currentPage, [self.webview pageCount]];
    if ([self canDecreaseFontSize]) {
        self.bookconfig.fontSize = self.bookconfig.fontSize - 20;
        [self setPageFontSize:self.bookconfig.fontSize];
    }
}

- (void) setPageFontSize: (NSUInteger) fontSize {
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '%lu%%'", (unsigned long)fontSize];
    [self.webview stringByEvaluatingJavaScriptFromString:jsString];
}

#pragma mark -Background

- (void)syncNightMode:(BOOL) nightMode {
    if (nightMode) {
        NSString *str = @"document.body.style.background='#0C0C0C';document.body.style.color='#464646'";
        [self.webview stringByEvaluatingJavaScriptFromString:str];
    } else {
        if (self.bookconfig.backgroundColor) {
            NSString *str = [NSString stringWithFormat:@"document.body.style.background='%@';", self.bookconfig.backgroundColor];
            [self.webview stringByEvaluatingJavaScriptFromString:str];
        } else {
            NSString *str = @"document.body.style.background='#FFFFFF';document.body.style.color='#000000'";
            [self.webview stringByEvaluatingJavaScriptFromString:str];
        }
    }
}

- (void)switchNightMode {
    self.bookconfig.nightMode = ! self.bookconfig.nightMode;
    [self syncNightMode:self.bookconfig.nightMode];
}


- (void)setPageBackground:(NSString *)color {
    NSString *str = [NSString stringWithFormat:@"document.body.style.background='%@';", color];
    [self.webview stringByEvaluatingJavaScriptFromString:str];
    self.bookconfig.backgroundColor = color;
    self.bookconfig.nightMode = FALSE;
}

- (void)toggleBookmark {
    NSString *position = [NSString stringWithFormat:@"%@:%@", self.book.chapters[self.chapterIndex], self.progress];
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

#pragma mark -Gesture

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

- (void)turnPageLeftAnimation {
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

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self hideBookToolView];
    [self hideBookFontView];
    self.currentPage = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;
    if (self.currentPage == self.startPage) {
        if (self.chapterIndex == 0) {
            [self switchShowTip:@"已到第一页"];
            
        } else {
            self.progress = [NSString stringWithFormat:@"%d/%d", 1, 1];
            [self switchToPrevChapter];
            [self turnPageLeftAnimation];
        }
    } else {
        [self jumpToPage:self.currentPage - 1];
        [self turnPageLeftAnimation];
    }
}

- (void)turnPageRightAnimation {
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

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    [self hideBookToolView];
    [self hideBookFontView];
    self.currentPage = self.webview.scrollView.contentOffset.x / self.webview.scrollView.frame.size.width + 1;
    if (self.currentPage == self.webview.pageCount) {
        if (self.chapterIndex == [self.book.chapters count] - 1) {
            [self switchShowTip:@"已到最后一页"];
        } else {
            if ([self canSwitchToNextChapter]) {
                [self switchToNextChapter];
                self.progress = nil;
                self.currentPage = self.startPage;
                [self turnPageRightAnimation];
            }
        }
    } else {
        [self jumpToPage:self.currentPage + 1];
        [self turnPageRightAnimation];
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

#pragma mark -Switch Page

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
    self.progress = [NSString stringWithFormat:@"%lu/%lu", self.currentPage, [self.webview pageCount]];
    NSString *position = [NSString stringWithFormat:@"%@:%@", self.book.chapters[self.chapterIndex], self.progress];
    [self.bookconfig setLastPosition:position ForBook:self.book.name];
}

@end
