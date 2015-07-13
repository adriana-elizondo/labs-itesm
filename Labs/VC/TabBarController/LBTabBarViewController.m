//
//  LMTabBarViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/10/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//
#import "LBTabBarViewController.h"
#import "LBCategoriesViewController.h"
#import "LBShoppingCartViewController.h"

@interface LBTabBarViewController ()

@end

@implementation LBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LBCategoriesViewController *categoriesVC = [[LBCategoriesViewController alloc] initWithNibName:@"LBCategoriesViewController" bundle:nil];
    categoriesVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    
    LBShoppingCartViewController *shoppingCartVC = [[LBShoppingCartViewController alloc] initWithNibName:@"LBShoppingCartViewController" bundle:nil];
    shoppingCartVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:2];
    
    UINavigationController *categoriesNC = [[UINavigationController alloc] initWithRootViewController:categoriesVC];
    UINavigationController *shoppingCartNC = [[UINavigationController alloc] initWithRootViewController:shoppingCartVC];
    self.viewControllers = @[categoriesNC, shoppingCartNC];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
