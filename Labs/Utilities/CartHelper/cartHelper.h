//
//  cartHelper.h
//  Labs
//
//  Created by alumno on 11/21/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBComponent.h"


@interface cartHelper : NSObject 

+ (void)AddItemToLocalCart: (NSMutableDictionary *)cart withComponent: (LBComponent *)component;
+ (void)AddItemToLocalCart:(NSMutableDictionary *) cart withComponentId: (NSString *)id_component andQuantity: (NSString *)quantity;
+(void)MinusItemToLocalCart: (NSMutableDictionary *)cart withComponentId: (NSString *)id_component andQuantity: (NSString *)quantity;

@end
