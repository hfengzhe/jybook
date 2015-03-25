//
//  BookFontView.m
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookFontView.h"

@implementation BookFontView

- (void)setupBrightnessProgress {
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [progress setProgress:0.5];
    [progress setProgressTintColor:[UIColor redColor]];
    [self addSubview:progress];
}

- (void)drawRect:(CGRect)rect {
    [self setupBrightnessProgress];
}




@end
