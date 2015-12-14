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

@implementation RequestHelper
    
+(void)getRequestWithQueryString:(NSString *)url response:(void(^)(id response, id error))responseBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData* responseObject) {
        responseBlock(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSInteger statusCode = [operation.response statusCode];
        NSLog(@"Error response: %@", error);
        
        UIAlertController* alert = [AlertController displayAlertWithTitle:[NSString stringWithFormat:@"Error: %ld", [operation.response statusCode]] withMessage:[error localizedDescription]];
        responseBlock(nil, alert);
        
    }];

}
+(void)getRequestWithQueryString:(NSString *)url withAuthToken:(NSString *)token response:(void (^)(id response, id error))responseBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString* auth_string = [NSString stringWithFormat:@"Token %@", token];
    //NSLog(@"auth string %@", auth_string);
    
    [manager.requestSerializer setValue:auth_string forHTTPHeaderField:@"Authorization"];
    //NSLog(@"Request with token %@", manager.requestSerializer);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData* responseObject) {
        //NSLog(@"headers: %@\n response %@ ", operation.response.allHeaderFields, operation.request.allHTTPHeaderFields);
        responseBlock(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertController* alert = [AlertController displayAlertWithTitle:[NSString stringWithFormat:@"Error: %ld", [operation.response statusCode]] withMessage:[error localizedDescription]];
        responseBlock(nil, alert);
    }];
}

+(void)putRequestWithQueryString:(NSString*)url withParams:(NSDictionary*)params withAuthToken:(NSString *)token response:(void(^)(id response, id error))responseBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //91e8e2efe3daf75850cd8598ef0b86b7c14780dc
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString* auth_string = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:auth_string forHTTPHeaderField:@"Authorization"];

    //NSLog(@"request : %@ \n body: %@", manager.requestSerializer.HTTPRequestHeaders, );
    [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success response: %@", operation.request.HTTPBodyStream);
        return responseBlock(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* body = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"request error: %@ \n method: %@ \n body error: %@",error,operation.request.HTTPMethod, body);
        
        return responseBlock(nil,responseBlock);
    }];
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
