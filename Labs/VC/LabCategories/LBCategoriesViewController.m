//
//  LBCategoriesViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/10/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//
#import "LBCategoriesViewController.h"
#import "LBComponentsViewController.h"
#import "LBCategory.h"
#import "LBCategoryTableViewCell.h"
#import "LBStudentModel.h"
#import "RequestHelper.h"
#import "UINavigationController+Transparent.h"

@interface LBCategoriesViewController ()<UITableViewDataSource, UITableViewDelegate>{
    LBLabModel *labModel;
    NSArray *categories;
    __weak IBOutlet UITableView *categoriesTableView;
}

@end

@implementation LBCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    labModel = [LBStudentModel sharedStudentClass].selectedLab;
    
    //Register class for collection view cell
    UINib *nib = [UINib nibWithNibName:@"LBCategoryTableViewCell" bundle: nil];
    [categoriesTableView registerNib:nib forCellReuseIdentifier:@"categoryCell"];
    
        [RequestHelper getRequestWithQueryString:labModel.category response:^(id response, id error) {
            categories = [[NSArray alloc] initWithArray: [LBCategory arrayOfModelsFromDictionaries:response]];
            [categoriesTableView reloadData];
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    LBCategory *category = [categories objectAtIndex:indexPath.row];
    cell.name.text = category.name;
    cell.image.image = [UIImage imageNamed:category.name];
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LBComponentsViewController *componentVC = [[LBComponentsViewController alloc] initWithNibName:@"LBComponentsViewController" bundle:nil];
    LBCategory *category = [categories objectAtIndex:indexPath.row];
    componentVC.idCategory = category.id_category;
    componentVC.componentsURL = labModel.component;
    
    [self.parentViewController.navigationController pushViewController:componentVC animated:YES];
}
@end
