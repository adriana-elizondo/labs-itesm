//
//  UserServices.h
//  Labs
//
//  Created by alumno on 3/29/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBStudentModel.h"

@interface UserServices : NSObject

+ (void)createStudentSingleton:(LBStudentModel *)student;
+ (void)storeUserInAppWithId:(NSString*)studentId token:(NSString *)token;
+ (void)removeUserInfo;
+ (BOOL)userIsLoggedIn;

@end
