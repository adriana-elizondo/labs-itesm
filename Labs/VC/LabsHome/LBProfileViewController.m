//
//  LBProfileViewController.m
//  Labs
//
//  Created by alumno on 11/29/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "LBProfileViewController.h"
#import "LBCategoryTableViewCell.h"
#import "LBStudentModel.h"
#import "Constants.h"
#import "LBLab.h"
#import "RequestHelper.h"
#import "AlertController.h"

@interface LBProfileViewController () {
    
    LBStudentModel* student;
    NSMutableArray* data;
    NSMutableArray* options;
    NSMutableArray* labs;
    NSMutableArray* credencial;
    NSArray* labs2add;
}

@end

@implementation LBProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Perfil";
    
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"LBCategoryTableViewCell" bundle: nil];
    [profileTable registerNib:nib forCellReuseIdentifier:@"categoryCell"];
    
    student = [LBStudentModel sharedStudentClass];
    
    
    //Arrays of sections in User profile
    data = [[NSMutableArray alloc] init];
    options = [[NSMutableArray alloc] init];
    credencial = [[NSMutableArray alloc] init];
    labs = [[NSMutableArray alloc] init];
    
    //Section 1 of User info
    NSDictionary* studentId = @{@"name": student.id_student, @"image": @"credential100"};
    NSDictionary* studentName = @{@"name": [NSString stringWithFormat:@"%@ %@ %@",student.name, student.last_name_1, student.last_name_2], @"image": @"profile100"};
    NSDictionary* studentCareer = @{@"name": student.career, @"image": @"university100"};
    NSDictionary* studentMail = @{@"name": student.mail, @"image": @"email100"};
    
    [data addObject:studentId];
    [data addObject:studentName];
    [data addObject:studentCareer];
    [data addObject:studentMail];
    
    //Section 2 of User id credential
    NSDictionary* validId = @{@"name": @"Credencial Valida", @"image": @"idok100"};
    NSDictionary* invalidId = @{@"name": @"Sin Credencial", @"image": @"id100"};
    
    if ([student.id_credential isEqualToString:@"0"]) {
        [credencial addObject:invalidId];
    } else {
        [credencial addObject:validId];
    }

    //Section 4 of user options
    NSDictionary* password = @{@"name": @"Cambiar contraseña", @"image": @"lock100"};
    NSDictionary* addLab = @{@"name": @"Agregar Laboratorio", @"image": @"engrane100"};
    
    [options addObject:password];
    [options addObject:addLab];

    if (student.labs.count == 0) {
        NSDictionary* lab = @{@"name": @"No tienes laboratorios"};
        [labs addObject:lab];
    } else {
        [self getLabsFromStudent:student.labs];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return data.count;
    } else if(section ==1){
        return credencial.count;
    } else if(section ==2){
        return labs.count;
    } else {
        return options.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return @" ";
    } else {
        return @"";
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    NSString* info;
    NSString* image;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        
        info = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
        image = [[data objectAtIndex:indexPath.row] objectForKey:@"image"];
        cell.userInteractionEnabled = NO;
    } else if(indexPath.section == 1) {
        
        info = [[credencial objectAtIndex:indexPath.row] objectForKey:@"name"];
        image = [[credencial objectAtIndex:indexPath.row] objectForKey:@"image"];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.userInteractionEnabled = NO;

    } else if (indexPath.section == 2) {
        
        info = [[labs objectAtIndex:indexPath.row] objectForKey:@"name"];
        image = info;
        cell.userInteractionEnabled = NO;

    } else if (indexPath.section == 3) {
        
        info = [[options objectAtIndex:indexPath.row] objectForKey:@"name"];
        image = [[options objectAtIndex:indexPath.row] objectForKey:@"image"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = indexPath.row == 0?YES:NO;

    }
    cell.name.text = info;
    cell.image.image = [UIImage imageNamed:image];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UIAlertController* alert = [self setAlertToChangePassword];
            [self presentViewController:alert animated:YES completion:nil];
            //NSLog(@"DISPLAY ALERT TO CHANGE PASSWORD");
        } else {
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"No disponible" withMessage:@"Por el momento no se pueden agregar mas laboratorios"];
            [self presentViewController:alert animated:YES completion:nil];
            /*[RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%s/labs",kBaseURL] response:^(id response, id error) {
                labs2add = [[NSArray alloc] initWithArray: [LBLab arrayOfModelsFromDictionaries:response]];
                //NSLog(@"Response from labs: %@",labs2add);
                UIAlertController* alert = [AlertController displayAlertWithLabArray:labs2add];
                [self presentViewController:alert animated:YES completion:nil];
            }];*/
        }
    }
}

#pragma mark - Utility

-(BOOL)validateTextfields:(NSArray*)textFields{
    
    for (UITextField* textField in textFields) {
        
        if ([textField.text isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

-(void)presentAlert {
    UIAlertController* alert = [AlertController displayAlertWithTitle:@"Campo invalido" withMessage:@"Favor de introducir un valor en los campos de texto."];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIAlertController*)setAlertToChangePassword {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Cambiar Contraseña"
                                  message:@"Introduce tu nueva contraseña"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Contraseña Actual";
        textField.secureTextEntry = YES;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Contraseña Nueva";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction* cambiar = [UIAlertAction actionWithTitle:@"Cambiar" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   if ([self validateTextfields:alert.textFields]) {
                                                       
                                                       NSString *currentPassword = ((UITextField *)[alert.textFields objectAtIndex:0]).text;
                                                       NSString *newPassword = ((UITextField *)[alert.textFields objectAtIndex:1]).text;
                                                       [self changePasswordToNewPassword:newPassword andCurrentPassword:currentPassword];
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   } else {
                                                       
                                                        [self presentAlert];
                                                   }
                                                  


                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:cambiar];
    [alert addAction:cancel];
    
   
    
    return alert;
}

#pragma mark - Service Calls

-(void)getLabsFromStudent: (NSArray *) studentLabs {
    
    for (NSString* lab in studentLabs) {
        
        [RequestHelper getRequestWithQueryString:lab response:^(id response, id error) {
            
            if (!error) {
                
                NSDictionary *responseDict = response;
                [labs addObject:responseDict];
                [profileTable reloadData];
            } else {
                
                [self presentViewController:error animated:YES completion:nil];
            }
        }];
    }
}

- (void)changePasswordToNewPassword:(NSString*)newPassword andCurrentPassword:(NSString*)currentPassword {
    
    NSDictionary *params = @{@"new_password":newPassword, @"re_new_password":newPassword, @"current_password":currentPassword};
    NSString *url = [NSString stringWithFormat:@"%s/auth/password/",kBaseURL];
    [RequestHelper postRequestWithQueryString:url withParams:params response:^(id response, id error) {
       
        if (!error) {
            
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Completo" withMessage:@"Contraseña cambiada exitosamente"];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}



@end
