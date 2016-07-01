//
//  LoginViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Edited by Armando Colomo on 8/4/16
//  Copyright (c) 2015 ITESM. All rights reserved.
//
#import "Constants.h"

//Utility
#import "LBStudentModel.h"
#import "RequestHelper.h"

//Services
#import "UserServices.h"

//ViewControllers
#import "LBLabsViewController.h"
#import "SignUpViewController.h"
#import "AlertController.h"
#import "LoginViewController.h"

//Frameworks
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintForFieldsAndButtons;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UIAlertController *validationAlert;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [self IsUserValid];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup 

-(void)setup
{
    //TODO: Add scroll view
    //TODO: Add loading Message
    self.view.backgroundColor = UIColorFromRGB(0x2B4C7F);
    
    self.loginButton.layer.cornerRadius = 2;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    self.signButton.layer.cornerRadius = 2;
    self.signButton.layer.borderWidth = 1;
    self.signButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.backgroundImage.alpha = .3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username = [defaults objectForKey:@"id_student"];
    self.usernameTxt.text = self.username;
    
    if (iPhone4) {
        self.layoutConstraintForFieldsAndButtons.constant = 20.0f;
    }
}

#pragma mark - TextField Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameTxt) {
        [textField resignFirstResponder];
        [self.passwordTxt becomeFirstResponder];
        
    } else if (textField == self.passwordTxt) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)dismissKeyboard {
    [self.usernameTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)logIn:(id)sender {

    if (![self fieldsAreValid]) {
        
        [self presentViewController:self.validationAlert animated:YES completion:nil];
        return;
    }
    
    [self loginUser];
}
- (IBAction)signUp:(id)sender {
    
    UIAlertController *alert = [AlertController displayAlertWithTitle:@"Inscripciones" withMessage:@"Estas interesado en usar la app? \n Acude a uno de los laboratorios para que te den de alta con tu credencial de estudiante."];
    [self presentViewController:alert animated:YES completion:nil];
    //SignUpViewController *signUpVC = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    //[self presentViewController:signUpVC animated:YES completion:nil];
}

#pragma mark - Utility

- (void)clearTextFields {
    self.usernameTxt.text = @"";
    self.passwordTxt.text = @"";
}

- (void)IsUserValid {
    if ([UserServices userIsLoggedIn]) {
        [self tokenStillValidForUser];
    }
}

#pragma mark - Validation

- (BOOL)fieldsAreValid {
    if (![self UsernameIsValid:self.usernameTxt.text]) {
        
        self.validationAlert = [AlertController displayAlertWithTitle:@"Usuario Invalido" withMessage:@"Favor de introducir una matricula con inicio A0 o A00"];
        [self.usernameTxt becomeFirstResponder];
        return NO;
    }
    
    if ([self.passwordTxt.text isEqualToString:@""]) {
        
        self.validationAlert = [AlertController displayAlertWithTitle:@"Contraseña Invalida" withMessage:@"Favor de introducir una contraseña"];
        [self.passwordTxt becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)UsernameIsValid:(NSString*)username {
    
    if ([self.usernameTxt.text isEqualToString:@""]) {
        return NO;
    }
    
    if ([[username substringToIndex:3] isEqualToString:@"A00"] || [[username substringToIndex:2] isEqualToString:@"A0"] ) {
        
        return YES;
    }
    return NO;
}

#pragma mark - Service Calls

-(void)loginUser {
    
    [RequestHelper loginUsername:self.usernameTxt.text withPassword:self.passwordTxt.text response:^(id response, id error) {
        if (!error) {
            [self getInfoFromUsername:self.usernameTxt.text];
            [self clearTextFields];
        } else {
            [self presentViewController:error animated:YES completion:nil];
            
        }
    }];
}

-(void)tokenStillValidForUser {
    [RequestHelper TokenIsValidForUser:self.username response:^(id response, id error) {
        if (response) {
            [self getInfoFromUsername:self.username];
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

@end
