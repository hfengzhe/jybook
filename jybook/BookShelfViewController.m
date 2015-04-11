//
//  HomeCollectionViewController.m
//  jybook
//
//  Created by yilang on 15/3/14.
//  Copyright (c) 2015年 yilang. All rights reserved.
//

#import "BookShelfViewController.h"
#import "Book.h"
#import "BookConfig.h"
#import "BookPageViewController.h"

@interface BookShelfViewController ()
@property (nonatomic, strong) NSArray *books;
@property (nonatomic, strong) BookConfig *bookconfig;
@end

@implementation BookShelfViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookconfig = [BookConfig sharedConfig];
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    // Do any additional setup after loading the view.
    NSArray *book1 = [NSArray arrayWithObjects:@"飞狐外传", @"笑傲江湖", nil];
    NSArray *book2 = [NSArray arrayWithObjects:@"雪山飞狐", @"书剑恩仇录", nil];
    NSArray *book3 = [NSArray arrayWithObjects:@"连城诀", @"神雕侠侣", nil];
    NSArray *book4 = [NSArray arrayWithObjects:@"天龙八部", @"侠客行", nil];
    NSArray *book5 = [NSArray arrayWithObjects:@"射雕英雄传", @"倚天屠龙记", nil];
    NSArray *book6 = [NSArray arrayWithObjects:@"白马啸西风", @"碧血剑", nil];
    NSArray *book7 = [NSArray arrayWithObjects:@"鹿鼎记", @"鸳鸯刀", nil];
    NSArray *book8 = [NSArray arrayWithObjects:@"越女剑", nil];
    self.books = [NSArray arrayWithObjects:book1,book2,book3,book4,book5,book6,book7,book8, nil];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [layout setSectionInset:UIEdgeInsetsMake(10, 10, 0, 10)];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:0.7 green:0.5 blue:0.1 alpha:0.3]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:0.9]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.books count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.books[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // Configure the cell
    NSString *imgpath = [[NSBundle mainBundle] pathForResource:self.books[indexPath.section][indexPath.row] ofType:@"jpg" inDirectory:@"cover"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgpath]];
    CGFloat width = (self.view.frame.size.width - 20 * 4) / 2.0;
    [image setFrame:CGRectMake(0, 0, width, width * 180 / 125)];
    cell.bounds = CGRectMake(0, 0, width, width * 180 / 125);
    [cell.contentView addSubview:image];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *resuableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        resuableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:0.9];
    }
    return resuableView;
}


#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showbook" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showbook"]) {

        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        NSString *name = self.books[selectedIndexPath.section][selectedIndexPath.row];
        Book *selectedBook = [[Book alloc] initWithName:name];
        
        BookPageViewController *bpvc = segue.destinationViewController;
        bpvc.book = selectedBook;
        
        NSString *position = [self.bookconfig getLastPositionForBook:selectedBook.name];
       
        if (position) {
            NSArray *array = [position componentsSeparatedByString:@":"];
            if ([array count] != 2) {
                NSLog(@"invalid book position:%@", position);
            }
            NSString *chapter = [array objectAtIndex:0];
            NSString *progress = [array objectAtIndex:1];
            bpvc.chapterIndex = [selectedBook.chapters indexOfObject:chapter];
            bpvc.progress = progress;
        } else {
            bpvc.chapterIndex = 0;
            bpvc.progress = nil;
        }
    }
}

@end
