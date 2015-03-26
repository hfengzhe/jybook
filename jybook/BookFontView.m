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
    [[nightModeBtn layer] setCornerRadius:20.0f];
    [[nightModeBtn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
    [[nightModeBtn layer] setBorderWidth:1.0f];
    [nightModeBtn addTarget:self action:@selector(nightModeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nightModeBtn];
}

- (void)setupColorBtn {
    UIColor *color1 = [UIColor colorWithRed:0.1 green:0.8 blue:0.3 alpha:0.4];
    UIColor *color2 = [UIColor colorWithRed:0.2 green:0.7 blue:0.7 alpha:0.4];
    UIColor *color3 = [UIColor colorWithRed:0.3 green:0.6 blue:0.3 alpha:0.4];
    UIColor *color4 = [UIColor colorWithRed:0.4 green:0.5 blue:0.2 alpha:0.4];
    UIColor *color5 = [UIColor colorWithRed:0.5 green:0.4 blue:0.8 alpha:0.4];
    UIColor *color6 = [UIColor colorWithRed:0.6 green:0.3 blue:0.1 alpha:0.4];
    NSArray *colors = [NSArray arrayWithObjects:color1,color2,color3,color4,color5,color6,nil];
    
    NSValue *rect1 = [NSValue valueWithCGRect:CGRectMake(20, 110, 30, 30)];
    NSValue *rect2 = [NSValue valueWithCGRect:CGRectMake(80, 110, 30, 30)];
    NSValue *rect3 = [NSValue valueWithCGRect:CGRectMake(140, 110, 30, 30)];
    NSValue *rect4 = [NSValue valueWithCGRect:CGRectMake(200, 110, 30, 30)];
    NSValue *rect5 = [NSValue valueWithCGRect:CGRectMake(260, 110, 30, 30)];
    NSValue *rect6 = [NSValue valueWithCGRect:CGRectMake(320, 110, 30, 30)];
    NSArray *rects = [NSArray arrayWithObjects:rect1,rect2,rect3,rect4,rect5,rect6,nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:rects forKeys:colors];
    for (UIColor *color in dict) {
        UIButton *btn = [[UIButton alloc] initWithFrame:[[dict objectForKey:color] CGRectValue]];
        [[btn layer] setCornerRadius:10.0f];
        [[btn layer] setBorderColor:[UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:0.8].CGColor];
        [btn setBackgroundColor:color];
        [btn addTarget:self action:@selector(colorTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)drawRect:(CGRect)rect {
    [self setupBrightnessProgress];
    [self setupFontSizeBtn];
    [self setupNightModeBtn];
    [self setupColorBtn];
}

#pragma mark -Action 

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
    NSLog(@"---night----");
}

- (void)colorTouchUpInside:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        NSLog(@"--color---");
    }
}

@end
