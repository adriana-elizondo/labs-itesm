//
//  UserServices.m
//  Labs
//
//  Created by alumno on 3/29/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import "UserServices.h"

@implementation UserServices

+(void)createStudentSingleton:(LBStudentModel *)student{
    [LBStudentModel sharedStudentClass].id_student = student.id_student;
    [LBStudentModel sharedStudentClass].name = student.name;
    [LBStudentModel sharedStudentClass].last_name_1 = student.last_name_1;
    [LBStudentModel sharedStudentClass].last_name_2 = student.last_name_2;
    [LBStudentModel sharedStudentClass].id_credential = student.id_credential;
    [LBStudentModel sharedStudentClass].career = student.career;
    [LBStudentModel sharedStudentClass].mail = student.mail;
    [LBStudentModel sharedStudentClass].labs = student.labs;
    [LBStudentModel sharedStudentClass].is_admin = student.is_admin;
}

+(void) storeUserInAppWithId:(NSString*)studentId password:(NSString*)password token:(NSString *)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:studentId forKey:@"id_student"];
    [defaults setObject:password forKey:@"password"];
    [defaults setObject:token forKey:@"token"];
    
    [defaults synchronize];
}

@end
