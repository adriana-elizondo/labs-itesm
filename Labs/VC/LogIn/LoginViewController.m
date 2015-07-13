//
//  LoginViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/9/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//
#import "Constants.h"
#import "LBLabsViewController.h"
#import "LBStudentModel.h"
#import "RequestHelper.h"
#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.enabled = NO;
    
    [self.usernameTxt.rac_textSignal
     subscribeNext:^(NSString *value) {
         self.loginButton.enabled = value.length > 0;
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginWithUserName:(NSString *)username password:(NSString *)passWord{
    [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%s/students/A01560365/", kBaseURL] response:^(id response, id error) {
        if (!error) {
            NSError *error;
             LBStudentModel *student =[[LBStudentModel alloc] initWithDictionary:response error:&error];
            if (error) {
                NSLog(@"Incorrect username or password %@", error);
            }else{
                [self createStudentSingleton:student];
            }
        }else{
            NSLog(@"Incorrect username or password");
        }
       
    }];
}

- (IBAction)logIn:(id)sender {
    [self loginWithUserName:self.usernameTxt.text password:self.usernameTxt.text];
}

-(void)createStudentSingleton:(LBStudentModel *)student{
    [LBStudentModel sharedStudentClass].url = student.url;
    [LBStudentModel sharedStudentClass].id_student = student.id_student;
    [LBStudentModel sharedStudentClass].name = student.name;
    [LBStudentModel sharedStudentClass].last_name_1 = student.last_name_1;
    [LBStudentModel sharedStudentClass].last_name_2 = student.last_name_2;
    [LBStudentModel sharedStudentClass].id_credential = student.id_credential;
    [LBStudentModel sharedStudentClass].career = student.career;
    [LBStudentModel sharedStudentClass].mail = student.mail;
    [LBStudentModel sharedStudentClass].labs = student.labs;
    
    LBLabsViewController *labsHomeVC = [[LBLabsViewController alloc] initWithNibName:@"LBLabsViewController" bundle:nil];
    UINavigationController *navicationController = [[UINavigationController alloc] initWithRootViewController:labsHomeVC];
    [self presentViewController:navicationController animated:YES completion:nil];
}
@end
