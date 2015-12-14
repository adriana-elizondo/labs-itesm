//
//  RequestHelper.h
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHelper : NSObject

+(void)getRequestWithQueryString:(NSString *)url response:(void(^)(id response, id error))responseBlock;
+(void)getRequestWithQueryString:(NSString*)url withAuthToken:(NSString*) token response:(void(^)(id response, id error))responseBlock;
+(void)putRequestWithQueryString:(NSString*)url withParams:(NSDictionary*)params withAuthToken:(NSString *)token response:(void(^)(id response, id error))responseBlock;

+(void)postRequestWithQueryString:(NSString *)url withParams:(NSDictionary*) params response:(void(^)(id response, id error))responseBlock;

@end
