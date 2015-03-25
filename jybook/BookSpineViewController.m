//
//  BookSpineViewController.m
//  jybook
//
//  Created by yilang on 15/3/25.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookSpineViewController.h"

@interface BookSpineViewController ()
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BookSpineViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array = [NSArray arrayWithObjects:@"目录", @"书签", nil];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:array];
    [segmentControl setSelectedSegmentIndex:0];
    [segmentControl setFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 20, 200, 40)];
    [segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)segmentAction:(UISegmentedControl *)seg {
    self.index = seg.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.index) {
        return [self.bpvc.book.bookmarks count];
    } else {
        return [self.bpvc.book.chapters count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"spineCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"spineCell"];
    }
    if (self.index) {
        cell.textLabel.text = [self.bpvc.book bookmarkTitleForPosition:self.bpvc.book.bookmarks[indexPath.row]];
    } else {
        cell.textLabel.text = [self.bpvc.book titleForChapter:self.bpvc.book.chapters[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index) {
        NSString *position = self.bpvc.book.bookmarks[indexPath.row];
        NSArray *array = [position componentsSeparatedByString:@":"];
        if ([array count] != 2) {
            NSLog(@"invalid bookmark position:%@", position);
        }
        NSString *chapter = [array objectAtIndex:0];
        NSString *page = [array objectAtIndex:1];
        
        self.bpvc.jumpPage = page.integerValue;
        [self.bpvc switchToChapter:[self.bpvc.book.chapters indexOfObject:chapter]];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        self.bpvc.jumpPage = self.bpvc.startPage;
        [self.bpvc switchToChapter:indexPath.row];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.bpvc.book.bookmarks];
        [array removeObjectAtIndex:indexPath.row];
        [self.bpvc.book setBookmarks:array];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
