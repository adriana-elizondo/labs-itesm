//
//  LBCartItem.h
//  Labs
//
//  Created by Adriana Elizondo on 7/12/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "JSONModel.h"

@interface LBCartItem : JSONModel
@property NSString *id_cart;
@property NSString *id_student_fk;
@property NSString *id_component_fk;
@property NSString *quantity;
@property BOOL checkout;
@property BOOL ready;
@property NSString <Optional>*date_checkout;
@property NSString <Ignore>*componentName;
@property NSString <Ignore>*categoryName;
@end
