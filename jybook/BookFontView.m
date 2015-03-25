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

- (void)setupFontMinusBtn {
    UIButton *fontMinusBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 100, 40)];
    [fontMinusBtn setTitle:@"A-" forState:UIControlStateNormal];
    [fontMinusBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [fontMinusBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [[fontMinusBtn layer] setCornerRadius:8.0f];
    [[fontMinusBtn layer] setBorderColor:[UIColor greenColor].CGColor];
    [[fontMinusBtn layer] setBorderWidth:1.0f];
    [fontMinusBtn addTarget:self action:@selector(fontMinusClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fontMinusBtn];
}

- (void)setupFontPlusBtn {
    UIButton *fontPlusBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 50, 100, 40)];
    [fontPlusBtn setTitle:@"A+" forState:UIControlStateNormal];
    [fontPlusBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [fontPlusBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [[fontPlusBtn layer] setCornerRadius:8.0f];
    [[fontPlusBtn layer] setBorderColor:[UIColor greenColor].CGColor];
    [[fontPlusBtn layer] setBorderWidth:1.0f];
    [fontPlusBtn addTarget:self action:@selector(fontMinusClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fontPlusBtn];
}

- (void)setupNightModeBtn {
    UIButton *nightModeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 50, 40, 40)];
    [nightModeBtn setTitle:@"🌙" forState:UIControlStateNormal];
    [nightModeBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [nightModeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [[nightModeBtn layer] setCornerRadius:8.0f];
    [[nightModeBtn layer] setBorderColor:[UIColor greenColor].CGColor];
    [[nightModeBtn layer] setBorderWidth:1.0f];
    [nightModeBtn addTarget:self action:@selector(nightModeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nightModeBtn];}

- (void)drawRect:(CGRect)rect {
    [self setupBrightnessProgress];
    [self setupFontMinusBtn];
    [self setupFontPlusBtn];
    [self setupNightModeBtn];
}

- (void)fontMinusClick:(id)sender {
    
}

- (void)fontPlusClick:(id)sender {
    
}

     
- (void)nightModeClick:(id)sender {
         
}
     
@end
