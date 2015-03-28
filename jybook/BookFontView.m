//
//  BookFontView.m
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookFontView.h"
#import "BookConfig.h"

@interface BookFontView()
@property (nonatomic, strong) BookConfig *bookconfig;
@property (nonatomic, strong) UIButton *nightModeBtn;
@end

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

- (UIButton *)nightModeBtn {
    if (!_nightModeBtn) {
        _nightModeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 50, 40, 40)];
        [_nightModeBtn setTitle:@"🌙" forState:UIControlStateNormal];
        [_nightModeBtn  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_nightModeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [[_nightModeBtn layer] setCornerRadius:20.0f];
        [[_nightModeBtn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
        [[_nightModeBtn layer] setBorderWidth:1.0f];
        [_nightModeBtn addTarget:self action:@selector(nightModeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nightModeBtn;
}

- (void)setupColorBtn {
    UIColor *color1 = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.7 green:0.6 blue:0.6 alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:0.6 green:0.6 blue:0.4 alpha:1.0];
    UIColor *color4 = [UIColor colorWithRed:0.4 green:0.6 blue:0.4 alpha:1.0];
    UIColor *color5 = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:1.0];
    UIColor *color6 = [UIColor colorWithRed:0.3 green:0.2 blue:0.2 alpha:1.0];
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

- (void)setupLineSpacingBtn {
    NSValue *rect1 =  [NSValue valueWithCGRect:CGRectMake(20, 150, 80, 40)];
    NSValue *rect2 = [NSValue valueWithCGRect:CGRectMake(150, 150, 80, 40)];
    NSValue *rect3 = [NSValue valueWithCGRect:CGRectMake(280, 150, 80, 40)];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:rect1,rect2,rect3, nil] forKeys: [NSArray arrayWithObjects:@"一",@"二",@"三", nil]];
    for (NSString *title in dict) {
        UIButton *btn = [[UIButton alloc] initWithFrame:[[dict objectForKey:title] CGRectValue]];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [[btn layer] setCornerRadius:8.0f];
        [[btn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
        [[btn layer] setBorderWidth:1.0f];
        
        [btn setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(lineSpacingTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(lineSpacingTouchDown:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:btn];
    }
}

- (id)init {
    if (self == [super init]) {
        self.bookconfig = [BookConfig sharedConfig];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self setupBrightnessProgress];
    [self setupFontSizeBtn];
    [self addSubview:self.nightModeBtn];
    [self setupColorBtn];
    [self setupLineSpacingBtn];
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
    [self.pageViewController switchNightMode];
    if (self.bookconfig.nightMode) {
        [self.nightModeBtn setTitle:@"☀️" forState:UIControlStateNormal];
    } else {
        [self.nightModeBtn setTitle:@"🌙" forState:UIControlStateNormal];
    }
}

- (NSString *)hexStringFromColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

- (void)colorTouchUpInside:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [self.pageViewController setPageBackground:[self hexStringFromColor:btn.backgroundColor]];
    }
}

- (void)lineSpacingTouchUpInside:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [[btn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
        NSString *title = [btn currentTitle];
        if ([title isEqualToString:@"一"]) {
            NSLog(@"一");
        } else if ([title isEqualToString:@"二"]) {
            NSLog(@"二");
        } else if ([title isEqualToString:@"三"]) {
            NSLog(@"三");
        }
    }
}

- (void)lineSpacingTouchDown:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [[btn layer] setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];
        
    }
}

@end
