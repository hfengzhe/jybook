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
    
    UIBarButtonItem *nextBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"▶︎" style:UIBarButtonItemStyleDone target:self action:@selector(switchToNextPage)];
    
    UIBarButtonItem *prevBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"◀︎" style:UIBarButtonItemStyleDone target:self action:@selector(switchToPrevPage)];
    
    UIBarButtonItem *nightmodeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"🌙" style:UIBarButtonItemStyleDone target:self action:@selector(switchNightMode)];
    
    UIBarButtonItem *bookmarkBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"📚" style:UIBarButtonItemStyleDone target:self action:@selector(toggleBookmark)];
    
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
    NSLog(@"----toggle bookmark----");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
