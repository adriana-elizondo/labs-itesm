//
//  imageHelper.m
//  Labs
//
//  Created by alumno on 4/8/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import "imageHelper.h"

@implementation imageHelper

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-()
@end
