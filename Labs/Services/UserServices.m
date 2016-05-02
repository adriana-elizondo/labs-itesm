//
//  UserServices.m
//  Labs
//
//  Created by alumno on 3/29/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import "UserServices.h"

@implementation UserServices

+ (void)createStudentSingleton:(LBStudentModel *)student {
    
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

+ (void)storeUserInAppWithId:(NSString*)studentId token:(NSString *)token {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:studentId forKey:@"id_student"];
    [defaults setObject:token forKey:@"token"];
    
    [defaults synchronize];
}

+ (void)removeUserInfo {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"id_student"];
    [defaults setObject:@"" forKey:@"token"];
    [defaults synchronize];
}

+ (BOOL)userIsLoggedIn {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *idStudent = [defaults objectForKey:@"id_student"];
    
    if (token.length != 0 && idStudent != 0) {
        return YES;
    }
    return NO;
}

@end
