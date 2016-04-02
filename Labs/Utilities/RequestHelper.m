//
//  RequestHelper.m
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "RequestHelper.h"
#import "AlertController.h"
#import <AFNetworking/AFNetworking.h>
#import "Constants.h"
#import "LBStudentModel.h"
#import "UserServices.h"

@implementation RequestHelper
    
+(void)getRequestWithQueryString:(NSString *)url response:(void(^)(id response, id error))responseBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData* responseObject) {
        NSLog(@"URL: { %@ } \nResponse: %@", url,responseObject);
        responseBlock(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSInteger statusCode = [operation.response statusCode];
        NSLog(@"URL: { %@ } \nError Response: %@", url, error);
        
        UIAlertController* alert = [AlertController displayAlertWithTitle:[NSString stringWithFormat:@"Error: %lu", (long)[operation.response statusCode]] withMessage:[error localizedDescription]];
        responseBlock(nil, alert);
        
    }];

}
+(void)getRequestWithQueryString:(NSString *)url withAuthToken:(NSString *)token response:(void (^)(id response, id error))responseBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString* authToken = [NSString stringWithFormat:@"Token %@", token];
    //NSLog(@"auth string %@", authToken);
    
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData* responseObject) {
        NSLog(@"URL: { %@ } Token: { %@ } \nResponse: %@", url, authToken, responseObject);
        responseBlock(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"URL: { %@ }  Token: { %@ } \nError Response: %@", url, authToken, error);

        UIAlertController* alert = [AlertController displayAlertWithTitle:[NSString stringWithFormat:@"Error: %ld", (long)[operation.response statusCode]] withMessage:[error localizedDescription]];
        responseBlock(nil, alert);
    }];
}

+(void)putRequestWithQueryString:(NSString*)url withParams:(NSDictionary*)params withAuthToken:(NSString *)token response:(void(^)(id response, id error))responseBlock {
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //91e8e2efe3daf75850cd8598ef0b86b7c14780dc
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString* authToken = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];

    //NSLog(@"request : %@ \n body: %@", manager.requestSerializer.HTTPRequestHeaders, );
    [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success response: %@", operation.request.HTTPBodyStream);
        return responseBlock(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* body = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"authToken: %@ \n request error: %@ \n method: %@ \n body error: %@",authToken, error,operation.request.HTTPMethod, body);
        
        return responseBlock(nil,responseBlock);
    }];
     */
    NSString* authToken = [NSString stringWithFormat:@"Token %@", token];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"url: %@ json string: %@",url, jsonString );
    
    
    //    NSString *testToken = @"6ecf0fe735487bcaab74c0fcd3ed57dc";
        NSURL *put_url = [NSURL URLWithString:url];
        NSData *JSONBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        //NSString *headerValue = [NSString stringWithFormat:@"Token %@" , token];
        NSMutableURLRequest *loginRequest = [[NSMutableURLRequest alloc] initWithURL:put_url];
        loginRequest.HTTPMethod = @"PUT";
        loginRequest.HTTPBody = JSONBody;
        [loginRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [loginRequest addValue:authToken forHTTPHeaderField:@"Authorization"];
        NSURLResponse *response = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:nil];
        NSString *txt = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"result; %@", txt);
    }
    
}

+(void)postRequestWithQueryString:(NSString *)url withParams:(NSDictionary*) params response:(void(^)(id response, id error))responseBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSDictionary *parameters = @{@"id_student": @"A01560365", @"password": @"101010"};
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"A01560365" password:@"101010"];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSData* responseObject) {
        NSLog(@"JSON: %@", responseObject);
        responseBlock(responseBlock, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseBlock(nil, error);
    }];
}

+(void)loginUsername:(NSString*)username withPassword:(NSString*)password response:(void (^)(id response, id error))responseBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:5];
    NSDictionary *parameters = @{@"password": password, @"id_student": username};
    
    [manager POST:[NSString stringWithFormat:@"%s/auth/login/", kBaseURL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *authToken = [responseObject objectForKey:@"auth_token"];
        [UserServices storeUserInAppWithId:username password:password token:authToken];
        return responseBlock(authToken,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        NSInteger statusCode = [operation.response statusCode];
        NSLog(@"Error response: %@", operation.response);
        if (!statusCode) {
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error de Respuesta" withMessage:@"No se ha alcanzado el servidor \n checa tu conexion de Internet"];
            return responseBlock(nil,alert);
        } else if (statusCode == 400) {
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error" withMessage:@"Usuario o contraseña Incorrecta" ];
            return responseBlock(nil,alert);
        } else if (statusCode == 404) {
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error de Respuesta" withMessage:@"No se ha alcanzado el servidor \n checa tu conexion de Internet"];
            return responseBlock(nil,alert);
        }
    }];
}

+(void)getUserData:(NSString*)username response:(void (^)(id response, id error))responseBlock {
    [self getRequestWithQueryString:[NSString stringWithFormat:@"%s/students/%@/", kBaseURL,username] response:^(id response, id error) {
        if (!error) {
            LBStudentModel *student =[[LBStudentModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [UserServices createStudentSingleton:student];
                return responseBlock(student,nil);
            } else {
                UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error Inesperado" withMessage:@"Favor de Intentar mas tarde"];
                return responseBlock(nil,alert);
            }
        }else{
            return responseBlock(nil,error);
        }
    }];
}
/*
+(void)loginUserWithAccountParams:(NSDictionary*) response:(void(^)(id response, id error))responseBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id_student": @"A01560365", @"password": @"101010"};
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"A01560365" password:@"101010"];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSData* responseObject) {
        NSLog(@"JSON: %@", responseObject);
        responseBlock(responseBlock, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseBlock(nil, error);
    }];
}*/
@end
