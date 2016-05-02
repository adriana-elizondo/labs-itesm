//
//  Constants.h
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#define kBaseURL "http://labs.chi.itesm.mx:8080"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define iPhone4 ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE

#define kMonths @[@"Enero", @"Febrero", @"Marzo", @"Abril", @"Mayo", @"Junio", @"Julio", @"Agosto", @"Septiembre", @"Octubre", @"Noviembre", @"Diciembre"];

#define kDays @[@"domingo",@"lunes",@"martes",@"miercoles",@"jueves",@"viernes",@"sabado"];

@end
