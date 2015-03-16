//
//  BookViewController.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookViewController.h"
#import "BookCatalogTableViewCell.h"
#import "BookPageViewController.h"

@interface BookViewController ()

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.bookNavigationItem.title = self.book.name;
    self.bookmarkBarButtonItem.title = @"书签";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.book.chapters count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Catalog" forIndexPath:indexPath];

    [cell.chapterLabel setText:[self.book titleForChapter:self.book.chapters[indexPath.row]]];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showchapter"]) {
        NSUInteger selectedChapter = [self.tableView indexPathForSelectedRow].row;
        BookPageViewController *bpvc = segue.destinationViewController;
        //NSLog(@"selected row:%lul", (unsigned long)selectedChapter);
        NSString *path = [self.book contentPathForChapter:self.book.chapters[selectedChapter]];
        bpvc.url = [NSURL fileURLWithPath:path];
    }
}


@end
