//
//  LoginViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//
#import "Constants.h"
#import "LBLabsViewController.h"
#import "SignUpViewController.h"
#import "LBStudentModel.h"
#import "RequestHelper.h"
#import "AlertController.h"
#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


#import <AFNetworking/AFNetworking.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signButton;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup 

-(void)setup
{
    self.view.backgroundColor = UIColorFromRGB(0x23479E);
    //[self.usernameTxt setBackgroundColor:[UIColor whiteColor]];
    //[self.passwordTxt setBackgroundColor:[UIColor whiteColor]];
    
    self.loginButton.layer.cornerRadius = 2;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.signButton.layer.cornerRadius = 2;
    self.signButton.layer.borderWidth = 1;
    self.signButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    /*Method to diable button if there is no text.
     [self.usernameTxt.rac_textSignal
     subscribeNext:^(NSString *value) {
     self.loginButton.enabled = value.length > 0;
     }];
     */
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.usernameTxt.text = [defaults objectForKey:@"id_student"];
    self.passwordTxt.text = [defaults objectForKey:@"password"];
}

#pragma mark - TextField Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameTxt) {
        [textField resignFirstResponder];
        [self.passwordTxt becomeFirstResponder];
        
    } else if (textField == self.passwordTxt) {
        [textField resignFirstResponder];
        //[self loginWithUserName:self.usernameTxt.text password:self.passwordTxt.text];
    }
    return YES;
}

-(void)dismissKeyboard {
    [self.usernameTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)logIn:(id)sender {
    [self loginUser];
}
- (IBAction)signUp:(id)sender {
    
    SignUpViewController *signUpVC = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self presentViewController:signUpVC animated:YES completion:nil];
    /*
    NSString* login_url = [NSString stringWithFormat:@"%s/auth/login/", kBaseURL];
    NSString* signUp_url = [NSString stringWithFormat:@"%s/students/", kBaseURL];
    NSDictionary *authLogin = @{@"id_student": self.usernameTxt.text, @"password": self.passwordTxt.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:5];
    NSDictionary *parameters = @{@"name": @"Ilse",
                                 @"last_name_1": @"Nuñez",
                                 @"last_name_2": @"Nuñez",
                                 @"id_credential":@"0",
                                 @"career": @"IBT",
                                 @"mail": @"A00756123@itesm.mx",
                                 @"id_student": @"A00756123",
                                 @"password":@"101010"};
    
    [manager POST:login_url parameters:authLogin success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"token successfull %@", responseObject);
        NSString *authToken = [responseObject objectForKey:@"auth_token"];
     
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", @"91e8e2efe3daf75850cd8598ef0b86b7c14780dc"] forHTTPHeaderField:@"Authorization"];
        
        [manager POST:signUp_url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success sign up: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error sign up: %@", error);
        }];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error login; %@", error);
    }];
         */
}

#pragma mark - Service Calls

-(void)loginUser {
    [RequestHelper loginUsername:self.usernameTxt.text withPassword:self.passwordTxt.text response:^(id response, id error) {
        if (!error) {
            [self getInfoFromUsername:self.usernameTxt.text];
        } else {
            [self presentViewController:error animated:YES completion:nil];
        }
    }];
}

-(void)getInfoFromUsername:(NSString*)username {
    [RequestHelper getUserData:username response:^(id response, id error) {
        
        LBLabsViewController *labsHomeVC = [[LBLabsViewController alloc] initWithNibName:@"LBLabsViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:labsHomeVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
