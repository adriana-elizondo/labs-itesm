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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.usernameTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
}

-(void)loginWithUserName:(NSString *)username password:(NSString *)passWord{
    NSString* login_url = [NSString stringWithFormat:@"%s/auth/login/", kBaseURL];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:5];
    NSDictionary *parameters = @{@"id_student": username, @"password": passWord};
    
    //Loading alert: NOT WORKING
    //UIAlertController* alert = [AlertController displayLoadingAlertWithTitle:@"Iniciando Sesion..." withMessage:@""];
    
    [manager POST:login_url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Present loading alert: NOT WORKING
        //[self presentViewController:alert animated:YES completion:nil];
        
        //AUTH TOKEN
         NSString *authToken = [responseObject objectForKey:@"auth_token"];
        
        //UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error de Respuesta" withMessage:@"Intenta mas tarde"];
        
        //GET DATA FROM LOGGED IN STUDENT
        [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%s/students/%@/", kBaseURL,username] response:^(id response, id error) {
            if (!error) {
                //NSError *error;
                LBStudentModel *student =[[LBStudentModel alloc] initWithDictionary:response error:&error];
                if (error) {
                    
                    //[self presentViewController:error animated:YES completion:nil];
                }else{
                    //NSLog(@"Found user");
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [self storeUserInApp:username withPassword:passWord andToken:authToken];
                    [self createStudentSingleton:student];
                }
            }else{
                //NSLog(@"Server response failed %@", error);
                [self presentViewController:error animated:YES completion:nil];
            }
            
        }];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSInteger statusCode = [operation.response statusCode];
        //NSLog(@"Error response: %@", operation.response);
        if (!statusCode) {
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error de Respuesta" withMessage:@"No se ha alcanzado el servidor \n checa tu conexion de Internet"];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if (statusCode == 400) {
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error" withMessage:@"Usuario o contraseña Incorrecta" ];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if (statusCode == 404) {
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error de Respuesta" withMessage:@"No se ha alcanzado el servidor \n checa tu conexion de Internet"];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

-(void) storeUserInApp:(NSString*) id_student withPassword:(NSString*) pwd andToken: (NSString *) token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:id_student forKey:@"id_student"];
    [defaults setObject:pwd forKey:@"password"];
    [defaults setObject:token forKey:@"token"];
    
    [defaults synchronize];
    //NSLog(@"Data Stored");
}

- (IBAction)logIn:(id)sender {
    [self loginWithUserName:self.usernameTxt.text password:self.passwordTxt.text];
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

-(void)createStudentSingleton:(LBStudentModel *)student{
   // [LBStudentModel sharedStudentClass].url = student.url;
    [LBStudentModel sharedStudentClass].id_student = student.id_student;
    [LBStudentModel sharedStudentClass].name = student.name;
    [LBStudentModel sharedStudentClass].last_name_1 = student.last_name_1;
    [LBStudentModel sharedStudentClass].last_name_2 = student.last_name_2;
    [LBStudentModel sharedStudentClass].id_credential = student.id_credential;
    [LBStudentModel sharedStudentClass].career = student.career;
    [LBStudentModel sharedStudentClass].mail = student.mail;
    [LBStudentModel sharedStudentClass].labs = student.labs;
    
    LBLabsViewController *labsHomeVC = [[LBLabsViewController alloc] initWithNibName:@"LBLabsViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:labsHomeVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

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

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
