//
//  BookSliderInfoView.m
//  jybook
//
//  Created by yilang on 15/3/28.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookSliderInfoView.h"
@interface BookSliderInfoView()

@end

@implementation BookSliderInfoView

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100, self.frame.size.height/2 - 20, 200, 40)];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)drawRect:(CGRect)rect {
    [self addSubview:self.titleLabel];
}

@end
