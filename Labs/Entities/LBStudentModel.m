//
//  LBStudent.m
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "LBStudentModel.h"

@implementation LBStudentModel

+ (LBStudentModel *)sharedStudentClass{
    static LBStudentModel *sharedStudent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStudent = [[self alloc] init];
    });
    return sharedStudent;
}

@end
