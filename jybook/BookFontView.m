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
@property (nonatomic, strong) UIButton *decreaseFontBtn;
@property (nonatomic, strong) UIButton *increaseFontBtn;
@property (nonatomic, strong) UIButton *nightModeBtn;
@end

@implementation BookFontView

- (void)setupBrightnessProgress {
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 40, 30)];
    [slider setValue:[UIScreen mainScreen].brightness];
    [slider setTintColor:[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.9]];
    [slider setBackgroundColor:[UIColor clearColor]];
    [slider setThumbImage:[self.pageViewController drawSliderCircleImage] forState:UIControlStateNormal];
    
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
}

- (void)initBtnStyle:(UIButton *)Btn{
    [Btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [Btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [[Btn layer] setCornerRadius:8.0f];
    [[Btn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
    [[Btn layer] setBorderWidth:1.0f];
    
    [Btn setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8] forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateHighlighted];
}

- (UIButton *)increaseFontBtn {
    if (!_increaseFontBtn) {
        CGFloat width = (self.frame.size.width - 40 - 20 * 4) / 2;
        _increaseFontBtn = [[UIButton alloc] initWithFrame:CGRectMake(width + 20 * 2, 50, width, 40)];
        [_increaseFontBtn setTitle:@"A+" forState:UIControlStateNormal];
        [self initBtnStyle:_increaseFontBtn];
        [_increaseFontBtn addTarget:self action:@selector(fontSizeTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_increaseFontBtn addTarget:self action:@selector(fontSizeTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _increaseFontBtn;
}

- (UIButton *)decreaseFontBtn {
    if (!_decreaseFontBtn) {
        CGFloat width = (self.frame.size.width - 40 - 20 * 4) / 2;
        _decreaseFontBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, width, 40)];
        [_decreaseFontBtn setTitle:@"A-" forState:UIControlStateNormal];
        [self initBtnStyle:_decreaseFontBtn];
        [_decreaseFontBtn addTarget:self action:@selector(fontSizeTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_decreaseFontBtn addTarget:self action:@selector(fontSizeTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _decreaseFontBtn;
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
    
    CGFloat csize = (self.frame.size.width - 20 * 7) / 6;
    NSValue *rect1 = [NSValue valueWithCGRect:CGRectMake(20, 105, csize, 30)];
    NSValue *rect2 = [NSValue valueWithCGRect:CGRectMake(20 * 2 + csize, 105, csize, 30)];
    NSValue *rect3 = [NSValue valueWithCGRect:CGRectMake(20 * 3 + csize * 2, 105, csize, 30)];
    NSValue *rect4 = [NSValue valueWithCGRect:CGRectMake(20 * 4 + csize * 3, 105, csize, 30)];
    NSValue *rect5 = [NSValue valueWithCGRect:CGRectMake(20 * 5 + csize * 4, 105, csize, 30)];
    NSValue *rect6 = [NSValue valueWithCGRect:CGRectMake(20 * 6 + csize * 5, 105, csize, 30)];
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
    CGFloat lsize = (self.frame.size.width - 20 * 4) / 3;
    NSValue *rect1 =  [NSValue valueWithCGRect:CGRectMake(20, 150, lsize, 40)];
    NSValue *rect2 = [NSValue valueWithCGRect:CGRectMake(20 * 2 + lsize, 150, lsize, 40)];
    NSValue *rect3 = [NSValue valueWithCGRect:CGRectMake(20 * 3 + lsize * 2, 150, lsize, 40)];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:rect1,rect2,rect3, nil] forKeys: [NSArray arrayWithObjects:@"一",@"二",@"三", nil]];
    for (NSString *title in dict) {
        UIButton *btn = [[UIButton alloc] initWithFrame:[[dict objectForKey:title] CGRectValue]];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [[btn layer] setCornerRadius:8.0f];
        [[btn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
        [[btn layer] setBorderWidth:1.0f];
        
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
    [self addSubview:self.decreaseFontBtn];
    [self addSubview:self.increaseFontBtn];
    [self addSubview:self.nightModeBtn];
    [self setupColorBtn];
    [self setupLineSpacingBtn];
}

#pragma mark -Update view status

- (void)enableBtn:(UIButton *)btn {
    [btn setEnabled:YES];
    [btn setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8] forState:UIControlStateNormal];
    [[btn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
}

- (void)disableBtn:(UIButton *)btn {
    [btn setEnabled:NO];
    [btn setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.3] forState:UIControlStateNormal];
    [[btn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.3].CGColor];
}

- (void)updateFontViewStatus {
    if ([self.pageViewController canIncreaseFontSize]) {
        [self enableBtn:self.increaseFontBtn];
    } else {
        [self disableBtn:self.increaseFontBtn];
    }
    if ([self.pageViewController canDecreaseFontSize]) {
        [self enableBtn:self.decreaseFontBtn];
    } else {
        [self disableBtn:self.decreaseFontBtn];
    }
}

#pragma mark -Action 

- (void)sliderValueChanged: (id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)sender;
        [[UIScreen mainScreen] setBrightness:slider.value];
        [self.bookconfig setBrightness:slider.value];
    }
}

- (void)fontSizeTouchUpInside:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [[btn layer] setBorderColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8].CGColor];
        NSString *title = [btn currentTitle];
        if ([title isEqualToString:@"A-"]) {
            [self.pageViewController decreaseFontSize];
        } else if ([title isEqualToString:@"A+"]) {
            [self.pageViewController increaseFontSize];
        }
        [self updateFontViewStatus];
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
            [self.pageViewController setLineHeight:1];
        } else if ([title isEqualToString:@"二"]) {
            [self.pageViewController setLineHeight:2];
        } else if ([title isEqualToString:@"三"]) {
            [self.pageViewController setLineHeight:3];
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
