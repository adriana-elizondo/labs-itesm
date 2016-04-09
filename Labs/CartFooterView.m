//
//  CartFooterView.m
//  Labs
//
//  Created by alumno on 4/8/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import "CartFooterView.h"

@implementation CartFooterView

-(void)setupView
{
    UIImage *checkout = [UIImage imageNamed:@"cartCheck100"];
    UIImage *delete = [UIImage imageNamed:@"cartEmpty100"];
    
    [self.orderButton setImage:checkout forState:UIControlStateNormal];
    [self.orderButton setTitle:@"Ordenar" forState:UIControlStateNormal];
    
    [self.deleteButton setImage:delete forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"Borrar" forState:UIControlStateNormal];

}

@end
