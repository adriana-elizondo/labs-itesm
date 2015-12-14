//
//  UINavigationController+Transparent.m
//  Labs
//
//  Created by Adriana Elizondo on 7/10/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "UINavigationController+Transparent.h"

@implementation UINavigationController (Transparent)
- (void)presentTransparentNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self setNavigationBarHidden:NO animated:YES];
}

- (void)presentNormalNavigationBar
{
    [self.navigationBar setTranslucent:NO];
    [self setNavigationBarHidden:NO animated:YES];
}

- (void)hideTransparentNavigationBar
{
    [self setNavigationBarHidden:YES animated:NO];
    [self.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:[[UINavigationBar appearance] isTranslucent]];
    [self.navigationBar setShadowImage:[[UINavigationBar appearance] shadowImage]];
}
@end
