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
#import "LBLabModel.h"
#import "LBLabsViewController.h"
#import "LBTabBarViewController.h"
#import "LBProfileViewController.h"
#import "RequestHelper.h"
#import "UINavigationController+Transparent.h"
#import "UserServices.h"

@interface LBLabsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    __weak IBOutlet UICollectionView *labsCollectionView;
    
    LBStudentModel *student;
    LBLabModel *labModel;
    NSMutableArray *labs;
    __weak IBOutlet UIView *emptyView;
}


@end

@implementation LBLabsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    student = [LBStudentModel sharedStudentClass];
    [self setupNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

-(void)setupNavigation {
    
    [self.navigationController presentTransparentNavigationBar];
    self.title = @"Labs";
    
    UIImage* image = [UIImage imageNamed:@"profile100"];
    UIImage* logout = [UIImage imageNamed:@"logout100"];
    UIBarButtonItem *userBtn = [[UIBarButtonItem alloc]
                                initWithImage:[self imageWithImage:image scaledToSize:CGSizeMake(30, 30)]
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(userProfile:)];
    
    UIBarButtonItem *logoutBtn = [[UIBarButtonItem alloc]
                                  initWithImage:[self imageWithImage:logout scaledToSize:CGSizeMake(30, 30)]
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(logoutUser:)];
    
    self.navigationItem.leftBarButtonItem = userBtn;
    self.navigationItem.rightBarButtonItems= [NSArray arrayWithObjects:logoutBtn,nil];
    [self getLabsFromStudent:student.labs];
    
    //Register class for collection view cell
    UINib *nib = [UINib nibWithNibName:@"LBLabsCollectionViewCell" bundle: nil];
    [labsCollectionView registerNib:nib forCellWithReuseIdentifier:@"labCell"];
    
}

#pragma mark - Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return labs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"labCell";
    
    LBLabsCollectionViewCell *labsCell = (LBLabsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary* lab = [labs objectAtIndex:indexPath.row];
    
    NSString *labName = [lab objectForKey:@"name"];
    labsCell.image.image = [UIImage imageNamed:labName];
    labsCell.labName.text = labName;
    return labsCell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat size = (self.view.frame.size.width / 2);
    return  CGSizeMake(size - 20, size - 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

#pragma mark - Collection View Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* lab = [labs objectAtIndex:indexPath.row];
    [self pushToViewControllerWithLab:lab];
}

#pragma mark - Button Actions

-(void)logoutUser:(UIButton*)sender {
    
    [UserServices removeUserInfo];
    [self pushToLoginView];
}
-(void)userProfile:(UIButton*)sender {
    
    [self pushToUserProfile];
}


#pragma mark - Navigation Handler

-(void)pushToViewControllerWithLab:(NSDictionary*)lab {
    [RequestHelper getRequestWithQueryString:[lab objectForKey:@"link"] response:^(id response, id error) {
        NSError *jsonError;
        labModel =[[LBLabModel alloc] initWithDictionary:response error:&jsonError];
        if (!error) {
            [LBStudentModel sharedStudentClass].selectedLab = labModel;
            LBTabBarViewController *tabBar = [[LBTabBarViewController alloc] initWithNibName:@"LBTabBarViewController" bundle:nil];
            [self.navigationController pushViewController:tabBar animated:YES];
        }else {
            [self presentViewController:error animated:YES completion:nil];
        }
    }];
}

-(void)pushToUserProfile {
    LBProfileViewController* profile = [[LBProfileViewController alloc] initWithNibName:@"LBProfileViewController" bundle:nil];
    [self.navigationController pushViewController:profile animated:YES];
}

-(void)pushToLoginView {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utility

-(void)getLabsFromStudent: (NSArray *) studentLabs {
    labs = [[NSMutableArray alloc] init];
    if (studentLabs.count == 0) {
        [self setImageForEmptyData];
    } else {
        
        for (NSString* lab in studentLabs) {
            [RequestHelper getRequestWithQueryString:lab response:^(id response, id error) {
                //NSLog(@"requesting lab: %@", lab );
                if (!error) {
                    NSDictionary *responseDict = response;
                    [labs addObject:responseDict];
                    [labsCollectionView reloadData];
                } else {
                    [self presentViewController:error animated:YES completion:nil];
                }
            }];
        }
    }
}



#pragma mark - Image Utils

-(void)setImageForEmptyData {
    emptyView.hidden = NO;
    emptyView.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:@"empty"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithImage:image scaledToSize:CGSizeMake(150, 150)]];
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 250, 150)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = @"No hay Laboratorios \n Agrega uno en tu perfil";
    
    [emptyView addSubview:imageView];
    [emptyView addSubview:label];
    
    [label setCenter:CGPointMake(emptyView.frame.size.width / 2, emptyView.frame.size.height / 2)];
    [imageView setCenter:CGPointMake(emptyView.frame.size.width / 2, emptyView.frame.size.height / 2)];

    [labsCollectionView setBackgroundColor:[UIColor clearColor]];
    [labsCollectionView reloadData];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
