//
//  BookmarkViewController.m
//  jybook
//
//  Created by yilang on 15/3/16.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookmarkViewController.h"
#import "BookmarkTableViewCell.h"
#import "BookPageViewController.h"

@interface BookmarkViewController ()

@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.book.bookmarks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkcell" forIndexPath:indexPath];
    cell.bookmarkLabel.text = [self.book bookmarkTitleForPosition:self.book.bookmarks[indexPath.row]];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.book.bookmarks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"enterbookmark"]) {
        NSUInteger index = [self.tableView indexPathForSelectedRow].row;
        NSString *position = self.book.bookmarks[index];
        NSArray *array = [position componentsSeparatedByString:@":"];
        if ([array count] != 2) {
            NSLog(@"invalid bookmark position:%@", position);
        }
        NSString *chapter = [array objectAtIndex:0];
        NSString *page = [array objectAtIndex:1];
        
        BookPageViewController *bpvc = segue.destinationViewController;
        
        bpvc.chapterIndex = [self.book.chapters indexOfObject:chapter];
        NSString *path = [self.book contentPathForChapter:chapter];
        bpvc.url = [NSURL fileURLWithPath:path];
        bpvc.book = self.book;
        bpvc.currentPage = page.integerValue;
    }
}


@end
