//
//  ToastHelper.h
//  Labs
//
//  Created by alumno on 4/8/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ToastTypeNormal,
    ToastTypeAlert,
    ToastTypeCompletion
}ToastType;

@interface ToastHelper : NSObject

+(void)showToastWithMessage:(NSString*)message toastType:(ToastType)toastType;

@end
