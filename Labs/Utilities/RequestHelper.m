//
//  RequestHelper.m
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "RequestHelper.h"
#import <AFNetworking/AFNetworking.h>

@implementation RequestHelper
    
+(void)getRequestWithQueryString:(NSString *)url response:(void(^)(id response, id error))responseBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData* responseObject) {
        responseBlock(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(nil, error);
    }];

}
@end
