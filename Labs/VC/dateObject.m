//
//  dateObject.m
//  Labs
//
//  Created by alumno on 10/16/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "dateObject.h"

@implementation dateObject

-(NSString *)setTitleFromDate:(NSDate *) dateValue{
    //NSString *title = @"Title";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterMediumStyle];  // nothing
    
    NSString *dateString = [df stringFromDate:dateValue];
    //[df release];
    
    return dateString;
}

@end
