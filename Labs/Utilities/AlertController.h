//
//  AlertController.h
//  Labs
//
//  Created by alumno on 11/30/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertController : UIAlertController

+(UIAlertController*)displayAlertWithTitle:(NSString*) title withMessage:(NSString*)message;
+(UIAlertController *)displayAlertWithLabArray: (NSArray *)labs;
+(UIAlertController*)displayLoadingAlertWithTitle: (NSString*) title withMessage:(NSString*)message;

@end
