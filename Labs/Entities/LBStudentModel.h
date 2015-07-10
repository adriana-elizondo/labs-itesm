//
//  LBStudent.h
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//
#import "JSONModel.h"
#import <Foundation/Foundation.h>

@interface LBStudentModel : JSONModel

@property NSString *url;
@property NSString *id_student;
@property NSString *name;
@property NSString *last_name_1;
@property NSString *last_name_2;
@property NSString *id_credential;
@property NSString *career;
@property NSString *mail;
@property NSArray *labs;

+ (LBStudentModel *)sharedStudentClass;

@end
