//
//  localCartItem.h
//  Labs
//
//  Created by alumno on 10/23/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface localCartItem : NSObject

@property NSString* id_student_fk;
@property NSString *id_component_fk;
@property NSString *quantity;

@property NSString *componentName;
@property NSString *categoryName;

+(localCartItem*) createCartItem: (NSString *) idComponent withItemName: (NSString*) name withQuantity: (NSString*) quantity byUserId: (NSString*) idStudent;

@end
