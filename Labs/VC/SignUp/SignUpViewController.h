//
//  SignUpViewController.h
//  Labs
//
//  Created by alumno on 12/7/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate> {
    
    __weak IBOutlet UIView *contentView;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIButton *btnSignUp;
    __weak IBOutlet UIButton *btnCancel;
    
    __weak IBOutlet UITextField *idStudent;
    __weak IBOutlet UITextField *name;
    __weak IBOutlet UITextField *lastName1;
    __weak IBOutlet UITextField *lastName2;
    __weak IBOutlet UITextField *career;
    __weak IBOutlet UITextField *email;
    __weak IBOutlet UITextField *password;
}
- (IBAction)signUpUser:(id)sender;
- (IBAction)cancelSignUp:(id)sender;

@end
