//
//  LBComponent.m
//  Labs
//
//  Created by Adriana Elizondo on 7/12/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "LBComponent.h"

@implementation LBComponent


//Not used
+ (LBComponent *)sharedComponentsClass{
    static LBComponent *sharedComponents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedComponents = [[self alloc] init];
    });
    return sharedComponents;
}

@end
