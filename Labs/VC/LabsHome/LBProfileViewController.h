//
//  LBProfileViewController.h
//  Labs
//
//  Created by alumno on 11/29/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UITableView *profileTable;
}

@end
