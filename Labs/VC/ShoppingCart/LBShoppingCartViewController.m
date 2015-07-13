//
//  LBShoppingCartViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/12/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "LBShoppingCartViewController.h"
#import "LBShoppingCartTableViewCell.h"
#import "LBCartItem.h"
#import "LBLabModel.h"
#import "LBStudentModel.h"
#import "RequestHelper.h"

@interface LBShoppingCartViewController ()<UITableViewDataSource, UITableViewDelegate>{
    LBLabModel *labModel;
    NSArray *cartItems;
}
@property (weak, nonatomic) IBOutlet UITableView *shoppingCartTV;

@end

@implementation LBShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    labModel = [LBStudentModel sharedStudentClass].selectedLab;

    //Register class for collection view cell
    UINib *nib = [UINib nibWithNibName:@"LBShoppingCartTableViewCell" bundle: nil];
    [self.shoppingCartTV registerNib:nib forCellReuseIdentifier:@"cartCell"];

    [RequestHelper getRequestWithQueryString:labModel.detailcart response:^(id response, id error) {
        NSArray *items = response;
        NSMutableArray *parsedItems = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in items) {
            LBCartItem *item = [[LBCartItem alloc] initWithDictionary:obj error:nil];
            
            [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%@%@",labModel.component, item.id_component_fk] response:^(id response, id error) {
                item.componentName = [response objectForKey:@"name"];
                
                [parsedItems addObject:item];
                
                if (parsedItems.count == items.count) {
                    cartItems = [[NSArray alloc] initWithArray:parsedItems];
                    [self.shoppingCartTV reloadData];
                }
            }];
        }
    }];
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
    LBCartItem *cartItem = [cartItems objectAtIndex:indexPath.row];
    cell.textLabel.text = cartItem.componentName;
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
