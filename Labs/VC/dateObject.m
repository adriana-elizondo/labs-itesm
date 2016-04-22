//
//  dateObject.m
//  Labs
//
//  Created by alumno on 10/16/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "dateObject.h"

@implementation dateObject

- (id)initWithDateString:(NSString*)dateString
{
    self = [super init];
    if(self) {
        if (!dateString) {
            self.date_compare = nil;
            self.date = nil;
            self.date_title = nil;
            return self;
        }
        
        NSString* trunk_date = [dateString substringToIndex:19];
        
        //Convert string to NSDate
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSDate *date = [dateFormatter dateFromString:trunk_date];
        //NSLog(@"date formateado- %@",[dateFormatter stringFromDate:date]);
        
        
        //store the data
        self.date_compare = dateString;
        self.date_title = [self setTitleFromDate:date];
        self.date = date;
    }
    return self;
}

-(NSString *)setTitleFromDate:(NSDate *) dateValue{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterMediumStyle];  // nothing
    
    NSString *dateString = [df stringFromDate:dateValue];
    //[df release];
    
    return dateString;
}

@end
