//
//  CartFooterView.h
//  Labs
//
//  Created by alumno on 4/8/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CartActionOrder,
    CartActionDelete
}CartAction;

@protocol CartFooterDelegate <NSObject>
- (void)actionForCart:(CartAction)cartAction;
@end

@interface CartFooterView : UIView
@property (nonatomic, assign) NSObject <CartFooterDelegate> *delegate;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
