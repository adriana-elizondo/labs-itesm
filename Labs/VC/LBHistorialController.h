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
    NSArray* categories;
    __weak IBOutlet UITableView *HistorialTable;
    NSMutableArray *date_sections;
    NSUserDefaults* defaults;
    NSString *auth_token;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}

-(NSMutableArray *)getDatesFromHistorial:(NSArray *) historial;
-(NSArray *)orderArrayOfDates:(NSMutableArray*) array;
-(NSMutableArray *)deleteDuplicates:(NSMutableArray*) array;
-(dateObject *)getDateTitle:(NSString*) item;
-(void)getComponents;
-(void)getHistorial;
-(void)getCategories;

@end
