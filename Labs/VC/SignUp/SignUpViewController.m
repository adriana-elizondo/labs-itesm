//
//  SignUpViewController.m
//  Labs
//
//  Created by alumno on 12/7/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "SignUpViewController.h"
#import "Constants.h"
#import "RequestHelper.h"
#import "AlertController.h"
#import <AFNetworking/AFNetworking.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [scrollView layoutIfNeeded];
    scrollView.contentSize = contentView.bounds.size;
    scrollView.backgroundColor = UIColorFromRGB(0X23479E);
    scrollView.scrollEnabled = YES;
    contentView.backgroundColor = UIColorFromRGB(0X23479E);
    
    btnSignUp.layer.cornerRadius = 2;
    btnSignUp.layer.borderWidth = 1;
    btnSignUp.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnCancel.layer.cornerRadius = 2;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scrollView.backgroundColor = UIColorFromRGB(0x23479E);
    
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    //scrollView.showsHorizontalScrollIndicator = YES;
    //scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height *2);
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)signUpUser {
    
    NSString* signUp_url = [NSString stringWithFormat:@"%s/students/", kBaseURL];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:5];
    NSDictionary *parameters = @{@"name": name.text,
                                 @"last_name_1": lastName1.text,
                                 @"last_name_2": lastName2.text,
                                 @"id_credential":@"0",
                                 @"career": career.text,
                                 @"mail": email.text,
                                 @"id_student": idStudent.text,
                                 @"password":password.text,
                                 @"labs": @[@"http://labs.chi.itesm.mx:8080/labs/Electronica/"]
                                 };

    //[manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", @"91e8e2efe3daf75850cd8598ef0b86b7c14780dc"] forHTTPHeaderField:@"Authorization"];
    
    [manager POST:signUp_url
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
              NSLog(@"success sign up: %@", responseObject);
              [self dismissViewControllerAnimated:YES completion:nil];
              
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertController* alert = [AlertController displayAlertWithTitle:@"No disponible"
                                                              withMessage:@"El registro de alumnos esta deshabilitado."];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == password) {
        [textField resignFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UI Actions

- (IBAction)signUpUser:(id)sender {
    //check all textfields
    [self signUpUser];
}

- (IBAction)cancelSignUp:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
