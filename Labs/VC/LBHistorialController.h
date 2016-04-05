//
//  LBHistorialController.h
//  Labs
//
//  Created by alumno on 10/14/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHistorialTableViewCell.h"
#import "RequestHelper.h"
#import "LBStudentModel.h"
#import "LBHistorialItem.h"
#import "dateObject.h"
#import "LBHistorialItemViewController.h"
#import "LBComponent.h"
#import "UINavigationController+Transparent.h"
#import "LBCategoryTableViewCell.h"
#import "LBCategory.h"



@interface LBHistorialController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    LBLabModel *labModel;
    NSArray *historial;
    NSArray* components;
    NSMutableDictionary *orderedDictionary;
    NSArray* categories;
    __weak IBOutlet UITableView *HistorialTable;
    NSMutableArray *dateSections;
    NSUserDefaults* defaults;
    NSString *token;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}


@end
