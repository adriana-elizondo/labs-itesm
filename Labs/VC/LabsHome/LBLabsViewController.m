//
//  LBLabsViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//
#import "Constants.h"
#import "LBLabsCollectionViewCell.h"
#import "LBStudentModel.h"
#import "LBLabsViewController.h"

@interface LBLabsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    __weak IBOutlet UILabel *welcomeTxt;
    __weak IBOutlet UICollectionView *labsCollectionView;
    
    LBStudentModel *student;
}

@end

@implementation LBLabsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    student = [LBStudentModel sharedStudentClass];
    welcomeTxt.text = [NSString stringWithFormat:@"Bienvenido %@ %@!\nEscoge tu laboratorio", student.name, student.last_name_1];
    
    //Register class for collection view cell
    UINib *nib = [UINib nibWithNibName:@"LBLabsCollectionViewCell" bundle: nil];
    [labsCollectionView registerNib:nib forCellWithReuseIdentifier:@"labCell"];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return student.labs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"labCell";
    
    LBLabsCollectionViewCell *labsCell = (LBLabsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *labName = student.labs[indexPath.row];
    NSString *shortenedName = [labName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%s/labs/", kBaseURL] withString:@""] ;
    labsCell.labName.text = [shortenedName substringToIndex:shortenedName.length -1];
    return labsCell;
}

#pragma mark collection view cell layout / size
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat size = (self.view.frame.size.width / 2);
    return  CGSizeMake(size - 20, size - 20);
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

#pragma mark - Collection view delegate
@end
