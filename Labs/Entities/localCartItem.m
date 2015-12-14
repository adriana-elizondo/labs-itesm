//
//  localCartItem.m
//  Labs
//
//  Created by alumno on 10/23/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "localCartItem.h"

@implementation localCartItem

+(localCartItem*) createCartItem: (NSString *) idComponent withItemName: (NSString*) name withQuantity: (NSString*) quantity byUserId: (NSString*) idStudent {
  
    localCartItem* item = [[localCartItem alloc] init];
    item.id_student_fk = idStudent;
    item.id_component_fk = idComponent;
    item.quantity = quantity;
    item.componentName = name;
    return item;
    
}

@end
