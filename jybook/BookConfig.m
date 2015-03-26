//
//  BookConfig.m
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookConfig.h"
@interface BookConfig()
@property (nonatomic, strong) NSUserDefaults *user;
@end

@implementation BookConfig

@synthesize nightMode = _nightMode;
@synthesize backgroundColor = _backgroundColor;
@synthesize fontSize = _fontSize;
@synthesize lineSpacing = _lineSpacing;
@synthesize brightness  = _brightness;

+ (id)sharedConfig {
    static BookConfig *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
    });
    return sharedConfig;
}

- (id)init {
    if (self == [super init]) {
        self.user = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (BOOL)nightMode {
    if (!_nightMode) {
        _nightMode = [self.user boolForKey:@"nightMode"];
    }
    return _nightMode;
}

- (void)setNightMode:(BOOL)nightMode {
    _nightMode = nightMode;
    [self.user setBool:nightMode forKey:@"nightMode"];
}

- (NSString *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [self.user objectForKey:@"backgroundColor"];
    }
    return _backgroundColor;
}

- (void)setBackgroundColor:(NSString *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self.user setObject:backgroundColor forKey:@"backgroundColor"];
}

- (NSUInteger)fontSize {
    if (!_fontSize) {
        _fontSize = [self.user integerForKey:@"fontSize"];
    }
    return _fontSize;
}

- (void)setFontSize:(NSUInteger)fontSize {
    _fontSize = fontSize;
    [self.user setInteger:fontSize forKey:@"fontSize"];
}

- (NSUInteger)lineSpacing {
    if (!_lineSpacing) {
        _lineSpacing = [self.user integerForKey:@"lineSpacing"];
    }
    return _lineSpacing;
}

- (void)setLineSpacing:(NSUInteger)lineSpacing{
    _lineSpacing = lineSpacing;
    [self.user setInteger:lineSpacing forKey:@"lineSpacing"];
}

- (CGFloat)brightness {
    if (!_brightness) {
        _brightness = [self.user doubleForKey:@"brightness"];
    }
    return _brightness;
}

- (void)setBrightness:(CGFloat)brightness {
    _brightness = brightness;
    [self.user setDouble:brightness forKey:@"brightness"];
}

- (NSArray *)getBookmarksForBook:(NSString *)bookname {
    return [self.user objectForKey:[NSString stringWithFormat:@"bookmark->%@", bookname]];
}

- (void)setBookmarks:(NSArray *)bookmarks ForBook:(NSString *)bookname {
    [self.user setObject:bookmarks forKey:[NSString stringWithFormat:@"bookmark->%@", bookname]];
}

- (NSString *)getLastPositionForBook: (NSString *)bookname {
    return [self.user objectForKey:[NSString stringWithFormat:@"lastPos->%@", bookname]];
}

- (void)setLastPosition:(NSString *)position ForBook:(NSString *)bookname {
    [self.user setObject:position forKey:[NSString stringWithFormat:@"lastPos->%@", bookname]];
}

@end
