//
//  HomeCollectionViewController.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookShelfViewController.h"
#import "Book.h"
#import "BookViewController.h"

@interface BookShelfViewController ()
@property (nonatomic, strong) NSArray *books;
@end

@implementation BookShelfViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSArray *)books {
    if (_books == nil) {
        _books = [NSArray arrayWithObjects:@"连城诀", @"鹿鼎记", @"射雕英雄传", @"神雕侠侣", @"书剑恩仇录", @"天龙八部", @"侠客行", @"笑傲江湖", @"雪山飞狐", @"倚天屠龙记", @"飞狐外传", @"碧血剑", nil];
    }
    return _books;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.books count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // Configure the cell
    NSString *imgname = [NSString stringWithFormat:@"%@.jpg", self.books[indexPath.row]];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgname]];
    [image setFrame:CGRectMake(10, 10, 125, 180)];
    [cell.contentView addSubview:image];

    return cell;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showbook" sender:self];
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showbook"]) {

        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        NSString *name = self.books[selectedIndexPath.row];
        Book *selectedBook = [[Book alloc] initWithName:name];
        
        BookViewController *bvc = segue.destinationViewController;
        bvc.book = selectedBook;

    }
}

@end
