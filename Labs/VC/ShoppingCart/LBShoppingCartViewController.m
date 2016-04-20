//
//  LBShoppingCartViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/12/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//
//ViewController
#import "LBShoppingCartViewController.h"
#import "LBShoppingCartTableViewCell.h"
#import "CartFooterView.h"

//Utility
#import "cartHelper.h"
#import "ToastHelper.h"
#import "RequestHelper.h"
#import "AlertController.h"


//Entities
#import "LBCartItem.h"
#import "LBLabModel.h"
#import "LBStudentModel.h"
#import "LBComponent.h"
#import "LBCategory.h"

//Frameworks
#import <AFNetworking/AFNetworking.h>

//Categories
#import "UINavigationController+Transparent.h"

@interface LBShoppingCartViewController ()<UITableViewDataSource, UITableViewDelegate, CartFooterDelegate>{
    LBLabModel *labModel;
    NSArray *cartItems;
    localCartModel *cartModel;
    NSArray *components;
    NSArray *categories;
    UIRefreshControl* refreshControl;
    NSMutableDictionary *cartDictionary;
    NSUserDefaults* defaults;
    NSString* token;
   
}

@property (weak, nonatomic) IBOutlet UITableView *shoppingCartTV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) CartFooterView* footerView;


@property BOOL isLocalCart;
@property BOOL orderComplete;

@end

@implementation LBShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Carrito";
    labModel = [LBStudentModel sharedStudentClass].selectedLab;

    //[self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
     
    refreshControl = [[UIRefreshControl alloc]init];
    [self.shoppingCartTV addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"CartFooterView" owner:self options:nil] objectAtIndex:0];
    self.footerView.delegate = self;
    
    //Register class for collection view cell
    UINib *nib = [UINib nibWithNibName:@"LBShoppingCartTableViewCell" bundle: nil];
    [self.shoppingCartTV registerNib:nib forCellReuseIdentifier:@"cartCell"];
    
    defaults = [NSUserDefaults standardUserDefaults];
    token = [defaults objectForKey:@"token"];

    cartDictionary = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"cart"]];
    
    categories = [[NSArray alloc] initWithArray: [LBCategory arrayOfModelsFromDictionaries:[defaults objectForKey:@"categories"]]];
   
    /*REQUEST ITEM DOES WORK
      NSString* itemUrl = [NSString stringWithFormat:@"%@?id_component=%@", labModel.component, @"2001"];
    NSLog(@"item url: %@", itemUrl);
     [RequestHelper getRequestWithQueryString:itemUrl withAuthToken:auth_token response:^(id response, id error) {
        NSLog(@"requeste complete");
        if(!error) {
            NSLog(@"Response: %@", response);
        }
        else {
            [self presentViewController:error animated:YES completion:nil];
        }
    }];
     */
    
    [RequestHelper getRequestWithQueryString:labModel.component withAuthToken:token response:^(id response, id error) {
        //NSLog(@"Components Response: %@", response);
        components = [[NSArray alloc] initWithArray: [LBComponent arrayOfModelsFromDictionaries:response]];

        if (self.isLocalCart) {
            [self getLocalCart:cartDictionary];
        } else {
            [self getCartOrder];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    defaults = [NSUserDefaults standardUserDefaults];
    cartDictionary = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"cart"]];
    
    [self.navigationController presentTransparentNavigationBar];
    
    self.shoppingCartTV.estimatedRowHeight = 60.0f;
    if (self.segControl.selectedSegmentIndex == 0) {
        self.isLocalCart = YES;
    } else {
        self.isLocalCart = NO;
    }
    [self checkCart];
}

- (void)refreshTable {
    //TODO: refresh your data
    if(self.isLocalCart) {
        [self getLocalCart:[defaults objectForKey:@"cart"]];
        [refreshControl endRefreshing];
        [self.shoppingCartTV reloadData];
    } else {
        [self getCartOrder];
    }
    
}

-(void)getLocalCart: (NSMutableDictionary*) localCart {
    NSMutableArray* parsedCart = [[NSMutableArray alloc] init];
    if (localCart.count == 0) {
        [self.activityIndicator stopAnimating];
        [self setImageForEmptyDataWithMessage:@"Carrito Vacio \n Agrega Componentes a tu carrito"];
    } else {
        [self.shoppingCartTV setBackgroundView:nil];
        for (id key in localCart) {
        
            localCartItem* item = [[localCartItem alloc] init];
            //NSLog(@"Component id: %@ with Quantity: %@",key, [localCart objectForKey:key]);
        
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_component == %@", key];
            //NSLog(@"count components %lu", components.count);
            NSArray *filteredArray = [components filteredArrayUsingPredicate:predicate];
            LBComponent* component = [filteredArray objectAtIndex:0];
        
            predicate = [NSPredicate predicateWithFormat:@"id_category == %@", component.id_category_fk];
            NSArray *filteredArray2 = [categories filteredArrayUsingPredicate:predicate];
            LBCategory* category = [filteredArray2 objectAtIndex:0];
        
            item = [localCartItem createCartItem:key withItemName:component.name withQuantity:[localCart objectForKey:key] byUserId:[LBStudentModel sharedStudentClass].id_student];
        
            item.categoryName = category.name;
            //NSLog(@"Item: %@", item);
            [parsedCart addObject:item];
        }
    }
    
    [self.activityIndicator stopAnimating];
    cartItems = [[NSArray alloc] initWithArray:parsedCart];
    [self.shoppingCartTV reloadData];
    
}

-(void)getCartOrder {
    NSString* student_id = [LBStudentModel sharedStudentClass].id_student;
    NSString* cartUrl = [NSString stringWithFormat:@"%@?%@=%@", labModel.detailcart,@"id_student_fk",student_id];
    [self.shoppingCartTV setBackgroundView:nil];
    
    [RequestHelper getRequestWithQueryString:cartUrl withAuthToken:token response:^(id response, id error) {
        NSArray *items = response;
        
        NSMutableArray *parsedItems = [[NSMutableArray alloc] init];
        if (items.count == 0)
        {
            cartItems = [[NSArray alloc] init];
            [self setImageForEmptyDataWithMessage:@"No hay ninguna orden pendiente"];
            [self.activityIndicator stopAnimating];
            [refreshControl endRefreshing];

        } else {
            for (NSDictionary *obj in items)
            {
                LBCartItem *item = [[LBCartItem alloc] initWithDictionary:obj error:nil];
            
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_component == %@", item.id_component_fk];
                NSArray *filteredArray = [components filteredArrayUsingPredicate:predicate];
                LBComponent* component = [filteredArray objectAtIndex:0];
            
                predicate = [NSPredicate predicateWithFormat:@"id_category == %@", component.id_category_fk];
                NSArray *filteredArray2 = [categories filteredArrayUsingPredicate:predicate];
                LBCategory* category = [filteredArray2 objectAtIndex:0];
            
                item.componentName = component.name;//[response objectForKey:@"name"];
                item.categoryName = category.name;
                [parsedItems addObject:item];
            
                if (parsedItems.count == items.count)
                {
                    cartItems = [[NSArray alloc] initWithArray:parsedItems];
                    [self.activityIndicator stopAnimating];
                    [refreshControl endRefreshing];
                    [self.shoppingCartTV reloadData];
                }
            }
            [refreshControl endRefreshing];
        }
    }];
}

-(void)checkCart {
    NSString* student_id = [LBStudentModel sharedStudentClass].id_student;
    NSString* cartUrl = [NSString stringWithFormat:@"%@?%@=%@", labModel.detailcart,@"id_student_fk",student_id];
    
    [RequestHelper getRequestWithQueryString:cartUrl withAuthToken:token response:^(id response, id error) {
        NSArray *items = response;
        if (items.count != 0) {
            NSDictionary* item = [items objectAtIndex:0];
        
            LBCartItem *cartItem = [[LBCartItem alloc] initWithDictionary:item error:nil];
            if (cartItem.ready) {
                UIAlertController* alert = [AlertController displayAlertWithTitle:@"Pedido Listo" withMessage:@"Pasa por los componentes que pediste \n con tu credencial"];
                [self presentViewController:alert animated:YES completion:nil];
                [self.segControl setTitle:@"Orden Lista" forSegmentAtIndex:1];
            }
            else {
                [self.segControl setTitle:@"Orden Pendiente" forSegmentAtIndex:1];
            }
        }
    }];
}

-(void)checkoutCart {
    NSMutableDictionary* emptyDict = [[NSMutableDictionary alloc] init];
  
    if (cartItems.count == 0) {
        UIAlertController* alert = [AlertController displayAlertWithTitle:@"Carrito Vacio" withMessage:@"Agrega componentes a tu pedido para poder Completarlo"];

        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    for(localCartItem* item in cartItems) {
        NSDictionary* params = @{@"id_student_fk": [LBStudentModel sharedStudentClass].id_student,
                                 @"id_component_fk": item.id_component_fk,
                                 @"quantity": item.quantity,
                                 @"checkout": @YES,
                                 @"ready": @NO,
                                 @"date_checkout": @""};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
        
        [manager POST:labModel.detailcart parameters:params success:^(AFHTTPRequestOperation *operation, NSData* responseObject)
        {
            [emptyDict setObject:item forKey:item.id_component_fk];
            
            if (emptyDict.count == cartItems.count) {
                NSMutableDictionary  *emptyDict = [[NSMutableDictionary alloc] init];
                cartItems = [[NSMutableArray alloc] init];
                [defaults setObject:emptyDict forKey:@"cart"];
                [defaults synchronize];
                UIAlertController* alert = [AlertController displayAlertWithTitle:@"Pedido Realizado" withMessage:@"Tu pedido esta siendo realizado \n Espera a que este listo."];
                
                [self presentViewController:alert animated:YES completion:nil];
                [self getLocalCart:[defaults objectForKey:@"cart"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertController* alert = [AlertController displayAlertWithTitle:@"Error" withMessage:@"No se pudo realizar el pedido"];
            
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }];
    }
}


- (IBAction)changeCart:(UISegmentedControl *)sender {

    NSInteger segmentNum = sender.selectedSegmentIndex;
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
    if (segmentNum == 0) {
        self.isLocalCart = YES;
        [self getLocalCart:[defaults objectForKey:@"cart"]];
    } else if (segmentNum == 1) {
        self.isLocalCart = NO;
        [self getCartOrder];
    }
}

- (void)actionForCart:(CartAction)cartAction {
    if (cartAction == CartActionOrder) {
        [self checkoutCart];
    } else if (cartAction == CartActionDelete) {
        [self deleteCart];
    }
}
-(void)deleteCart {
    cartDictionary = [[NSMutableDictionary alloc] init];
    [defaults setObject:cartDictionary forKey:@"cart"];
    [defaults synchronize];
    cartItems = [[NSMutableArray alloc] init];
    [ToastHelper showToastWithMessage:@"Carrito Borrado" toastType:ToastTypeAlert];
    [self getLocalCart:[defaults objectForKey:@"cart"]];
}

-(void)addToCart:(UIButton*)sender {
    cartDictionary = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"cart"]];
    localCartItem* item = [cartItems objectAtIndex:sender.tag];
    [cartHelper AddItemToLocalCart:cartDictionary withComponentId:item.id_component_fk andQuantity:item.quantity];
    NSString* qty = [cartDictionary objectForKey:item.id_component_fk];
    item.quantity = qty;
    [self.shoppingCartTV reloadData];
}

-(void)minusToCart:(UIButton*)sender {
    cartDictionary = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"cart"]];
    localCartItem* item = [cartItems objectAtIndex:sender.tag];
    [cartHelper MinusItemToLocalCart:cartDictionary withComponentId:item.id_component_fk andQuantity:item.quantity];
    NSString* qty = [cartDictionary objectForKey:item.id_component_fk];
    item.quantity = qty;
    [self.shoppingCartTV reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cartItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    
    if (self.isLocalCart) {
        localCartItem* item = [cartItems objectAtIndex:indexPath.row];
        cell.name.text = item.componentName;
        cell.image.image = [UIImage imageNamed:item.categoryName];
        cell.quantity.text = item.quantity;
        
        [cell.btnMinus setImage:[UIImage imageNamed:@"Minus-32"] forState:UIControlStateNormal];
        [cell.btnAdd setImage:[UIImage imageNamed:@"Plus-32"] forState:UIControlStateNormal];
        
        cell.btnAdd.tag = indexPath.row;
        cell.btnMinus.tag = indexPath.row;
        cell.quantity.tag = indexPath.row;
        
        cell.btnMinus.hidden = NO;
        cell.btnAdd.hidden = NO;
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.btnAdd addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnMinus addTarget:self action:@selector(minusToCart:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
    LBCartItem *cartItem = [cartItems objectAtIndex:indexPath.row];
        cell.name.text = cartItem.componentName;
    
        cell.image.image = [UIImage imageNamed:cartItem.categoryName];
        cell.quantity.text = cartItem.quantity;
        if (cartItem.ready) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.btnMinus.hidden = YES;
        cell.btnAdd.hidden = YES;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isLocalCart){
        return YES;
    } else {
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSMutableDictionary *cart = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"cart"]];
        LBCartItem* item = [cartItems objectAtIndex:indexPath.row];
        [cart removeObjectForKey:item.id_component_fk];
        [defaults setObject:cart forKey:@"cart"];
        [defaults synchronize];
        [self getLocalCart:[defaults objectForKey:@"cart"]];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    [self.footerView setFrame:CGRectMake(0,0,self.footerView.frame.size.width, self.footerView.frame.size.height)];
    return self.footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ( self.isLocalCart && cartItems.count != 0 ) {
        return 50;
    } else {
        return 0;
    }
}

-(void)setImageForEmptyDataWithMessage: (NSString *) message {
    UIView* view = [[UIView alloc]initWithFrame:self.shoppingCartTV.bounds];
    view.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:@"empty"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithImage:image scaledToSize:CGSizeMake(150, 150)]];
      UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 250, 150)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = message;
    imageView.center = view.center;
    label.center = view.center;
    [view addSubview:imageView];
    [view addSubview:label];

    [self.shoppingCartTV setBackgroundView:view];
    self.shoppingCartTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.shoppingCartTV setBackgroundColor:[UIColor clearColor]];
    [self.shoppingCartTV reloadData];
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"Cart items: %@", [cartItems objectAtIndex:indexPath.row]);
    //LBCartItem* item = [cartItems objectAtIndex:indexPath.row];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
