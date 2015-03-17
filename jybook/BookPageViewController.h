//
//  BookPageViewController.h
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookPageViewController : UIViewController
@property (nonatomic, strong) Book *book;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, strong) NSURL *url;

@end
