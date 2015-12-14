//
//  LBComponentTableViewCell.h
//  Labs
//
//  Created by Adriana Elizondo on 7/12/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBComponentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;



@end
