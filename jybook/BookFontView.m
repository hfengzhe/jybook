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
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width - 40, 40)];
    [progress setProgress:0.5];
    [progress setProgressTintColor:[UIColor redColor]];
    [progress setContentMode:UIViewContentModeCenter];
    [self addSubview:progress];
}

- (void)setupFontSizeBtn {
    NSValue *minusRect =  [NSValue valueWithCGRect:CGRectMake(20, 50, 100, 40)];
    NSValue *plusRect = [NSValue valueWithCGRect:CGRectMake(150, 50, 100, 40)];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:minusRect, plusRect, nil] forKeys:[NSArray arrayWithObjects:@"A-", @"A+", nil]];
    
    for (NSString *title in dict) {
        UIButton *fontSizeBtn = [[UIButton alloc] initWithFrame:[[dict objectForKey:title] CGRectValue]];
        
        [fontSizeBtn setTitle:title forState:UIControlStateNormal];
        [fontSizeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [fontSizeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [[fontSizeBtn layer] setCornerRadius:8.0f];
        [[fontSizeBtn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
        [[fontSizeBtn layer] setBorderWidth:1.0f];
        
        [fontSizeBtn setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8] forState:UIControlStateNormal];
        [fontSizeBtn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6] forState:UIControlStateHighlighted];
        
        [fontSizeBtn addTarget:self action:@selector(fontSizeTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [fontSizeBtn addTarget:self action:@selector(fontSizeTouchDown:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:fontSizeBtn];
    }
}

- (void)setupNightModeBtn {
    UIButton *nightModeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 50, 40, 40)];
    [nightModeBtn setTitle:@"🌙" forState:UIControlStateNormal];
    [nightModeBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [nightModeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [[nightModeBtn layer] setCornerRadius:8.0f];
    [[nightModeBtn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
    [[nightModeBtn layer] setBorderWidth:1.0f];
    [nightModeBtn addTarget:self action:@selector(nightModeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nightModeBtn];
}

- (void)drawRect:(CGRect)rect {
    [self setupBrightnessProgress];
    [self setupFontSizeBtn];
    [self setupNightModeBtn];
}

- (void)fontSizeTouchUpInside:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [[btn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
        NSString *title = [btn currentTitle];
        if ([title isEqualToString:@"A-"]) {
            NSLog(@"A-");
        } else if ([title isEqualToString:@"A+"]) {
            NSLog(@"A+");
        }
    }
}

- (void)fontSizeTouchDown:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [[btn layer] setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];

    }
}

- (void)nightModeClick:(id)sender {
         
}
     
@end
