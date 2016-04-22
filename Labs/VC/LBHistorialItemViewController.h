//
//  LBHistorialItemViewController.h
//  Labs
//
//  Created by alumno on 10/21/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHistorialItemTableViewCell.h"
#import "LBHistorialItem.h"
#import "dateObject.h"

@interface LBHistorialItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UITableView *itemTable;
    NSMutableArray *dataArray;
    NSMutableArray *titleArray;
}

@property(nonatomic, retain) LBHistorialItem *item;

@end
