//
//  BookConfig.m
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookConfig.h"

@implementation BookConfig
@synthesize nightMode = _nightMode;
@synthesize backgroundColor = _backgroundColor;
@synthesize fontSize = _fontSize;
@synthesize lineSpacing = _lineSpacing;
@synthesize brightness  = _brightness;

- (BOOL)nightMode {
    if (!_nightMode) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _nightMode = [user boolForKey:@"nightMode"];
    }
    return _nightMode;
}

- (void)setNightMode:(BOOL)nightMode {
    _nightMode = nightMode;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:nightMode forKey:@"nightMode"];
}

- (NSString *)backgroundColor {
    if (!_backgroundColor) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _backgroundColor = [user objectForKey:@"backgroundColor"];
    }
    return _backgroundColor;
}

- (void)setBackgroundColor:(NSString *)backgroundColor {
    _backgroundColor = backgroundColor;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:backgroundColor forKey:@"backgroundColor"];
}

- (NSUInteger)fontSize {
    if (!_fontSize) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _fontSize = [user integerForKey:@"fontSize"];
    }
    return _fontSize;
}

- (void)setFontSize:(NSUInteger)fontSize {
    _fontSize = fontSize;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:fontSize forKey:@"fontSize"];
}

- (NSUInteger)lineSpacing {
    if (!_lineSpacing) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _lineSpacing = [user integerForKey:@"lineSpacing"];
    }
    return _lineSpacing;
}

- (void)setLineSpacing:(NSUInteger)lineSpacing{
    _lineSpacing = lineSpacing;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:lineSpacing forKey:@"lineSpacing"];
}

- (CGFloat)brightness {
    if (!_brightness) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _brightness = [user doubleForKey:@"brightness"];
    }
    return _brightness;
}

- (void)setBrightness:(CGFloat)brightness {
    _brightness = brightness;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setDouble:brightness forKey:@"brightness"];
}

- (NSArray *)getBookmarksForBook:(NSString *)bookname {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:[NSString stringWithFormat:@"bookmark->%@", bookname]];
}

- (void)setBookmarks:(NSArray *)bookmarks ForBook:(NSString *)bookname {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:bookmarks forKey:[NSString stringWithFormat:@"bookmark->%@", bookname]];
}

@end
