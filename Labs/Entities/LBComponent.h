//
//  LBComponent.h
//  Labs
//
//  Created by Adriana Elizondo on 7/12/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "JSONModel.h"

@interface LBComponent : JSONModel
@property NSString *id_category_fk;
@property NSString *id_component;
@property NSString *name;
@property NSString <Optional>*note;
@property NSString *total;
@property NSString *available;
@property NSString  <Ignore>*quantity;

+ (LBComponent *) sharedComponentsClass;
@end
