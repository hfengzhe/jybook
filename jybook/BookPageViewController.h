//
//  BookPageViewController.h
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) NSString *chaptertext;

@end
