//
//  LBHistorialController.m
//  Labs
//
//  Created by alumno on 10/14/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "LBHistorialController.h"
#import "AlertController.h"

@interface LBHistorialController ()

@end

@implementation LBHistorialController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Historial";
    defaults = [NSUserDefaults standardUserDefaults];
    auth_token = [defaults objectForKey:@"token"];
    
    /*
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = refreshButton;
     */
    
    //GET all the urls from the lab
    labModel = [LBStudentModel sharedStudentClass].selectedLab;
    
    //set the nib so the table knows which cell its gonna load
    UINib *nib = [UINib nibWithNibName:@"LBCategoryTableViewCell" bundle: nil];
    [HistorialTable registerNib:nib forCellReuseIdentifier:@"categoryCell"];
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
    date_sections = [[NSMutableArray alloc] init];
    [self getCategories];
    [self getComponents];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getComponents {
    [RequestHelper getRequestWithQueryString:labModel.component withAuthToken:auth_token response:^(id response, id error) {
        if (!error) {
            //NSError *nError;
            components = [[NSArray alloc] initWithArray: [LBComponent arrayOfModelsFromDictionaries:response]];
            [self getHistorial];
            
        } else {
            
        }
    }];
}

-(void)getCategories {
    [RequestHelper getRequestWithQueryString:labModel.category withAuthToken:auth_token response:^(id response, id error) {
        if (!error) {
            //NSError *nError;
            categories = [[NSArray alloc] initWithArray: [LBCategory arrayOfModelsFromDictionaries:response]];
            //component = [[LBComponent alloc] initWithDictionary:response error:&nError];
            
        } else {
            
        }
    }];

}


-(void)getHistorial {
    //Call Historial del alumno
    [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%@?id_student_fk=%@",labModel.detailhistory,[LBStudentModel sharedStudentClass].id_student] response:^(id response, id error) {
        //NSLog(@"Historial Response %@", response);
        
        if (!error) {
            historial = [[NSArray alloc] initWithArray: [LBHistorialItem arrayOfModelsFromDictionaries:response]];
            if (historial.count == 0) {
                [activityIndicator stopAnimating];
                [self setImageForEmptyData];
            } else {
            date_sections = [self getDatesFromHistorial:historial];

            [activityIndicator stopAnimating];
            [HistorialTable reloadData];
            }
        } else {
            [activityIndicator stopAnimating];
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error" withMessage:@"No se pudo cargar el historial \n Intenta mas tarde"];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];

}

-(dateObject *)getDateTitle:(NSString*) dateString {
    dateObject* dateObj = [[dateObject alloc] init];
    
    //Truncating the date from the Json array
    NSString* trunk_date = [dateString substringToIndex:19];
    
    //Convert string to NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:trunk_date];
    //NSLog(@"date formateado- %@",[dateFormatter stringFromDate:date]);
    
    
    //store the data
    dateObj.date_compare = dateString;
    dateObj.date_title = [dateObj setTitleFromDate:date];
    dateObj.date = date;
    
    return dateObj;

}


-(NSMutableArray *)getDatesFromHistorial:(NSArray *) historial {
    NSMutableArray* dates = [[NSMutableArray alloc] init];
   // NSString *newDate = @"2015-08-08T12:12:12.20";
    //NSDate *dateNew;
    for (LBHistorialItem* item in historial) {
        //Store all date objects in dateObject
        dateObject* dateObj = [[dateObject alloc] init];
        
        dateObj = [self getDateTitle:item.date_out];
        [dates addObject:dateObj];
    
    }
    dates = [self deleteDuplicates:dates];
    dates = [NSMutableArray arrayWithArray:[self orderArrayOfDates:dates]];
    //[dates setArray:[[NSSet setWithArray:dates] allObjects]];
    //[NSMutableArray arrayWithArray:sortedArray];
    
    return dates;
}

-(NSArray *)orderArrayOfDates:(NSMutableArray*) array {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;

}

-(NSMutableArray *) deleteDuplicates:(NSMutableArray *)array {
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    NSMutableSet *names = [NSMutableSet set];
    for (id obj in array) {
        NSString* value = [obj date_title];
        if(![names containsObject:value]) {
            [newArray addObject:obj];
            [names addObject:value];
        }
    }
    //NSLog(@"Array completo = %lu", (unsigned long)array.count);
    //NSLog(@"Array nuevo = %lu", (unsigned long)newArray.count);
    
    return newArray;
}


#pragma mark - Table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return date_sections.count;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    dateObject* date = [date_sections objectAtIndex:section];
    
    return date.date_title;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows = 0;
    dateObject* dateObj = [date_sections objectAtIndex:section];
    for (LBHistorialItem* item in historial) {
        if ([item.date_out isEqualToString:dateObj.date_compare]) {
            numberOfRows += 1;
        }
    }
    //NSLog(@" rows for section %ld: %ld rows",section, (long)numberOfRows);
    return numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //LBHistorialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistorialCell" forIndexPath:indexPath];
    LBCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    
    dateObject* dateObj = [date_sections objectAtIndex:indexPath.section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date_out == %@", dateObj.date_compare];
    NSArray *filteredArray = [historial filteredArrayUsingPredicate:predicate];
    LBHistorialItem* item = [filteredArray objectAtIndex:indexPath.row];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"id_component == %@", item.id_component_fk];
    NSArray* filteredComponents = [components filteredArrayUsingPredicate:pred];

    LBComponent* component = [filteredComponents objectAtIndex:0];
    
    pred = [NSPredicate predicateWithFormat:@"id_category == %@", component.id_category_fk];
    NSArray* filteredCategories = [categories filteredArrayUsingPredicate:pred];
    LBCategory* category = [filteredCategories objectAtIndex:0];
    item.componentName = component.name;
    item.categoryName = category.name;
    cell.name.text = item.componentName;
    cell.image.image = [UIImage imageNamed:category.name];
    
    
    
    if([item.date_in length] != 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    
     return cell;

    /*LBShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    LBCartItem *cartItem = [cartItems objectAtIndex:indexPath.row];
    cell.textLabel.text = cartItem.componentName;
    */
    
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    dateObject* dateObj = [date_sections objectAtIndex:indexPath.section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date_out == %@", dateObj.date_compare];
    NSArray *filteredArray = [historial filteredArrayUsingPredicate:predicate];
    LBHistorialItem* item = [filteredArray objectAtIndex:indexPath.row];
    
    LBHistorialItemViewController *itemVC = [[LBHistorialItemViewController alloc] initWithNibName:@"LBHistorialItemViewController" bundle:nil];
    itemVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    itemVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    dateObject* dateO = [[dateObject alloc] init];
    if ([item.date_in length] == 0) {
        dateO.date_title = @"No entregado";
        itemVC.date_in = dateO;
        // item.date_in =
    } else {
        dateO = [self getDateTitle:item.date_in];
        itemVC.date_in = dateO;
    }
    
    //itemVC.date_in = [self getDateTitle:item.date_in];
    itemVC.date_out = [self getDateTitle:item.date_out];
    
    itemVC.item = item;
    
    //itemVC.modalPresentationStyle = [UIModalPresentationPopover mo]
    //[self.navigationController presentViewController:itemVC animated:NO completion:nil];
    [self.parentViewController.navigationController pushViewController:itemVC animated:YES];
    
}

-(void)refreshTable {
    [self getCategories];
    [self getComponents];
}

-(void)setImageForEmptyData {
    UIView* view = [[UIView alloc]initWithFrame:HistorialTable.bounds];
    view.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:@"empty"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithImage:image scaledToSize:CGSizeMake(150, 150)]];
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 250, 150)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = @"No hay Historial\n para mostrar";
    imageView.center = view.center;
    label.center = view.center;
    [view addSubview:imageView];
    [view addSubview:label];
    
    [HistorialTable setBackgroundView:view];
    HistorialTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [HistorialTable setBackgroundColor:[UIColor clearColor]];
    [HistorialTable reloadData];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
