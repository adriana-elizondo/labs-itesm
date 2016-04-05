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
#import "LBHistorialController.h"

@interface LBTabBarViewController ()

@end

@implementation LBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabNavigation];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

-(void)setupTabNavigation {
    UIImage *home = [self imageWithImage:[UIImage imageNamed:@"homeFilled100"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *historial = [self imageWithImage:[UIImage imageNamed:@"historial100"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *cart = [self imageWithImage:[UIImage imageNamed:@"cartFilled100"] scaledToSize:CGSizeMake(30, 30)];
    
    LBCategoriesViewController *categoriesVC = [[LBCategoriesViewController alloc] initWithNibName:@"LBCategoriesViewController" bundle:nil];
    categoriesVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Categorias" image:home tag:1];
    
    LBShoppingCartViewController *shoppingCartVC = [[LBShoppingCartViewController alloc] initWithNibName:@"LBShoppingCartViewController" bundle:nil];
    //shoppingCartVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:2];
    shoppingCartVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Carrito" image:cart tag:2];
    
    LBHistorialController *historialVC = [[LBHistorialController alloc] initWithNibName:@"LBHistorialController" bundle:nil];
    historialVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Historial" image:historial tag:2];
    
    UINavigationController *categoriesNC = [[UINavigationController alloc] initWithRootViewController:categoriesVC];
    
    UINavigationController *shoppingCartNC = [[UINavigationController alloc] initWithRootViewController:shoppingCartVC];
    
    UINavigationController *historialNC = [[UINavigationController alloc] initWithRootViewController:historialVC];
    self.viewControllers = @[categoriesNC, shoppingCartNC, historialNC];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
