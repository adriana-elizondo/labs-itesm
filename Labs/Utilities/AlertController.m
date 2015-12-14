//
//  AlertController.m
//  Labs
//
//  Created by alumno on 11/30/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "AlertController.h"
#import "LBLab.h"
#import "Constants.h"
#import "RequestHelper.h"
#import "LBStudentModel.h"

@interface AlertController ()

@end

@implementation AlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+(UIAlertController *)displayAlertWithTitle:(NSString*) title withMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   //NSLog(@"OK action");
                               }];
    [alert addAction:okAction];
    return alert;
    //[self presentViewController:alert animated:YES completion:nil];
}
+(UIAlertController *)displayAlertWithLabArray: (NSArray *)labs {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Laboratorios"
                                 message:@"Escoge uno"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"token"];
    NSString* studentId = [defaults objectForKey:@"id_student"];
   LBStudentModel* student = [LBStudentModel sharedStudentClass];
    
    NSString* url = [NSString stringWithFormat:@"%s/students/%@",kBaseURL,studentId];
    //NSDictionary *parameters = @{@"labs": @[@"http://labs.chi.itesm.mx:8080/labs/Electronica/"]};
    NSDictionary *parameters = @{@"name": student.name,
                                 @"last_name_1": student.last_name_1,
                                 @"last_name_2": student.last_name_2,
                                 @"id_credential":@"0",
                                 @"career": student.career,
                                 @"mail": student.mail,
                                 @"id_student": student.id_student,
                                 @"labs": @[@"http://labs.chi.itesm.mx:8080/labs/Electronica/"]
                                 };
    for (LBLab* lab in labs) {
        UIAlertAction* labAction = [UIAlertAction
                             actionWithTitle:lab.name
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 
                                 [RequestHelper putRequestWithQueryString:url withParams:parameters withAuthToken:token response:^(id response, id error) {
                                     NSLog(@"Response: %@", response);
                                 }];
                                 //NSLog(@"Added lab: %@", lab);
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
        [view addAction:labAction];
    }
    
    return view;
}

+(UIAlertController*)displayLoadingAlertWithTitle: (NSString*) title withMessage:(NSString*)message {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle: title
                                                               message: nil
                                                        preferredStyle: UIAlertControllerStyleAlert];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler:nil]];
    
    
    UIViewController *customVC     = [[UIViewController alloc] init];
    
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    [customVC.view addSubview:spinner];
    
    
    [customVC.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem: spinner
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:customVC.view
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0f
                                  constant:0.0f]];
    
    
    
    [customVC.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem: spinner
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:customVC.view
                                  attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0f
                                  constant:0.0f]];
    
    
    [alertController setValue:customVC forKey:@"contentViewController"];
    return alertController;
    
}

@end
