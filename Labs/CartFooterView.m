//
//  CartFooterView.m
//  Labs
//
//  Created by alumno on 4/8/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import "CartFooterView.h"



@implementation CartFooterView

- (IBAction)orderCartButtonPush:(id)sender {
    
    [self.delegate actionForCart:CartActionOrder];
}
- (IBAction)deleteCartButtonPush:(id)sender {
    
    [self.delegate actionForCart:CartActionDelete];
}

@end
