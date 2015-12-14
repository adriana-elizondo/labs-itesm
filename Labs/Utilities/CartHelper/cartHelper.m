//
//  cartHelper.m
//  Labs
//
//  Created by alumno on 11/21/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "cartHelper.h"

@implementation cartHelper

+ (void)AddItemToLocalCart: (NSMutableDictionary *)cart withComponent: (LBComponent *)component {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (component.quantity == nil) {
        component.quantity = @"1";
    } else {
        int value = component.quantity.intValue  + 1;
        component.quantity = [NSString stringWithFormat:@"%d", value];
        
    }
    [cart setObject:component.quantity forKey:component.id_component];
    
    
    [defaults setObject:cart forKey:@"cart"];
    [defaults synchronize];
    //NSLog(@"added to cart:%@", cart);
}

+ (void)AddItemToLocalCart:(NSMutableDictionary *) cart withComponentId: (NSString *)id_component andQuantity: (NSString *)quantity {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (quantity == nil) {
        quantity = @"1";
    } else {
        int value = quantity.intValue  + 1;
        quantity = [NSString stringWithFormat:@"%d", value];
    }
    [cart setObject:quantity forKey:id_component];
    
    
    [defaults setObject:cart forKey:@"cart"];
    [defaults synchronize];
    //NSLog(@"added to cart:%@", cart);
    
}

+(void)MinusItemToLocalCart: (NSMutableDictionary *)cart withComponentId: (NSString *)id_component andQuantity: (NSString *)quantity;{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int value;
    if (quantity == nil) {
        quantity = @"";
    } else {
        value = quantity.intValue  - 1;
        if (value < 1) {
            value = 1;
        }
        quantity = [NSString stringWithFormat:@"%d", value];
    }
    [cart setObject:quantity forKey:id_component];
    
    [defaults setObject:cart forKey:@"cart"];
    [defaults synchronize];
    //NSLog(@"Subracted to cart:%@", cart);
}

@end
