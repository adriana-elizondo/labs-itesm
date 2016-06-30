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

#pragma mark - ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

-(void)setup {
    
    self.title = @"Historial";
    defaults = [NSUserDefaults standardUserDefaults];
    token = [defaults objectForKey:@"token"];
    
    labModel = [LBStudentModel sharedStudentClass].selectedLab;
    
    UINib *nib = [UINib nibWithNibName:@"LBCategoryTableViewCell" bundle: nil];
    [HistorialTable registerNib:nib forCellReuseIdentifier:@"categoryCell"];
    
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
    dateSections = [[NSMutableArray alloc] init];
    orderedDictionary = [[NSMutableDictionary alloc] init];
    [self getCategories];
    [self getHistorial];
}

-(void)getCategories {
    [RequestHelper getRequestWithQueryString:labModel.category withAuthToken:token response:^(id response, id error) {
        if (!error) {
            categories = [[NSArray alloc] initWithArray: [LBCategory arrayOfModelsFromDictionaries:response]];
        }
    }];
}

-(void)getHistorial {
    [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%@?id_student_fk=%@",labModel.detailhistory,[LBStudentModel sharedStudentClass].id_student] response:^(id response, id error) {
        
        if (!error) {
            
            historial = [[NSArray alloc] initWithArray: [LBHistorialItem arrayOfModelsFromDictionaries:response]];
            if (historial.count == 0) {
                
                [activityIndicator stopAnimating];
                [self setImageForEmptyData];
            } else {
        
                dateSections = [self getDatesFromHistorial];
                [self fillOrderedHistorial];
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

-(void)fillOrderedHistorial {
    
    for (dateObject *sectionDate in dateSections ) {
        
        NSMutableArray *itemsInSection = [[NSMutableArray alloc] init];
        for (LBHistorialItem* item in historial) {
            if ([self compareString:item.date_out withDate:sectionDate.date]) {
                [itemsInSection addObject:item];
            }
        }
        [orderedDictionary setObject:itemsInSection forKey:sectionDate.date_title];
    }
}

-(NSMutableArray *)getDatesFromHistorial {
    NSMutableArray* dates = [[NSMutableArray alloc] init];
    for (LBHistorialItem* item in historial) {
        dateObject* dateObj = [[dateObject alloc] initWithDateString:item.date_out];
        [dates addObject:dateObj];
    }
    dates = [self deleteDuplicates:dates];
    dates = [NSMutableArray arrayWithArray:[self orderArrayOfDates:dates]];
    
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
   // NSLog(@"Array nuevo = %lu", (unsigned long)newArray.count);
    
    return newArray;
}


#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return dateSections.count;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    dateObject* date = [dateSections objectAtIndex:section];
    return date.date_title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    dateObject* dateObj = [dateSections objectAtIndex:section];
    NSArray* itemsInSection = [orderedDictionary objectForKey:dateObj.date_title];
    return itemsInSection.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    dateObject* dateSection = [dateSections objectAtIndex:indexPath.section];
    NSArray* itemsInSection = [orderedDictionary objectForKey:dateSection.date_title];
    LBHistorialItem *item = [itemsInSection objectAtIndex:indexPath.row];
    
    if (!item.categoryName && !item.componentName) {
    
    [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%@?id_component=%@",labModel.component,item.id_component_fk] withAuthToken:token response:^(id response, id error) {
        if (!error) {
            NSArray *componentsArray = [[NSArray alloc] initWithArray: [LBComponent arrayOfModelsFromDictionaries:response]];
            LBComponent *component = [componentsArray objectAtIndex:0];
            LBCategory *category = [categories objectAtIndex:([component.id_category_fk integerValue]-1)];
            item.categoryName = category.name;
            item.componentName = component.name;
            cell.name.text = item.componentName;
            cell.image.image = [UIImage imageNamed:category.name];
            if([item.date_in length] != 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }];
        
    } else {
        cell.name.text = item.componentName;
        cell.image.image = [UIImage imageNamed:item.categoryName];
        if([item.date_in length] != 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dateObject* dateSection = [dateSections objectAtIndex:indexPath.section];
    NSArray* itemsInSection = [orderedDictionary objectForKey:dateSection.date_title];
    LBHistorialItem *item = [itemsInSection objectAtIndex:indexPath.row];
    [self displayViewForHistorialItem:item];
}

-(void)refreshTable {
    [self getCategories];
    [self getHistorial];
}

#pragma mark - Navigation

-(void)displayViewForHistorialItem:(LBHistorialItem*)item {
    LBHistorialItemViewController *itemVC = [[LBHistorialItemViewController alloc] initWithNibName:@"LBHistorialItemViewController" bundle:nil];
    itemVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    itemVC.modalPresentationStyle = UIModalPresentationFullScreen;
    itemVC.item = item;
    [self.parentViewController.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - Utility

- (BOOL)compareString:(NSString*)dateString withDate:(NSDate*)date {
    NSString* trunk_date = [dateString substringToIndex:16];
    
    //Convert string to NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    
    NSDate *dateFromString = [dateFormatter dateFromString:trunk_date];
    if ([dateFromString isEqualToDate:date]) {
        return YES;
    }
    return NO;
}

#pragma mark - Image Utils

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

@end
