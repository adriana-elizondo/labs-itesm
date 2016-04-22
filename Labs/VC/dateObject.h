//
//  dateObject.h
//  Labs
//
//  Created by alumno on 10/16/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dateObject : NSObject

@property NSString* date_title;
@property NSString* date_compare;
@property NSDate* date;

- (id)initWithDateString:(NSString*)dateString;
-(NSString *)setTitleFromDate:(NSDate *) dateValue;

@end
