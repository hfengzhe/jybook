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

- (NSArray *)books {
    if (_books == nil) {
        _books = [NSArray arrayWithObjects:@"连城诀", @"鹿鼎记", @"射雕英雄传", @"神雕侠侣", @"书剑恩仇录", @"天龙八部", @"侠客行", @"笑傲江湖", @"雪山飞狐", @"倚天屠龙记", @"飞狐外传", @"碧血剑", @"越女剑", @"白马啸西风", @"鸳鸯刀",nil];
    }
    return _books;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookconfig = [BookConfig sharedConfig];
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.books count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // Configure the cell
    NSString *imgpath = [[NSBundle mainBundle] pathForResource:self.books[indexPath.row] ofType:@"jpg" inDirectory:@"cover"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgpath]];
    [image setFrame:CGRectMake(10, 10, 125, 180)];
    [cell.contentView addSubview:image];

    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *resuableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        resuableView.backgroundColor = [UIColor redColor];
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
        NSString *name = self.books[selectedIndexPath.row];
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
