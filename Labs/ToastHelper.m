//
//  ToastHelper.m
//  Labs
//
//  Created by alumno on 4/8/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import "ToastHelper.h"
#import <CRToast/CRToast.h>
#import "Constants.h"

@implementation ToastHelper

+(void)showToastWithMessage:(NSString*)message toastType:(ToastType)toastType {
    NSDictionary *toastOptions;
    if (toastType == ToastTypeNormal) {
        toastOptions = @{
                         kCRToastTextKey :message,
                         kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                         kCRToastBackgroundColorKey : UIColorFromRGB(0x23479E),
                         kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                         kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                         kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                         kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                         };
    } else if (toastType == ToastTypeAlert) {
        toastOptions = @{
                         kCRToastTextKey :message,
                         kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                         kCRToastBackgroundColorKey : [UIColor redColor],
                         kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                         kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                         kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                         kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight),
                         };
    }else if (toastType == ToastTypeAlert) {
        toastOptions = @{
                         kCRToastTextKey :message,
                         kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                         kCRToastBackgroundColorKey : [UIColor greenColor],
                         kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                         kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                         kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                         kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                         };
    }
    [CRToastManager showNotificationWithOptions:toastOptions completionBlock:nil];
}

@end
