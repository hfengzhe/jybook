//
//  BookSpineViewController.h
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookSpineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) Book *book;
@end
