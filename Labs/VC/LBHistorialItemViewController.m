//
//  LBHistorialItemViewController.m
//  Labs
//
//  Created by alumno on 10/21/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "LBHistorialItemViewController.h"

@interface LBHistorialItemViewController ()

@end

@implementation LBHistorialItemViewController

@synthesize item;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Detalles";
    
    
    
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"LBHistorialItemTableViewCell" bundle: nil];
    [itemTable registerNib:nib forCellReuseIdentifier:@"historialItemDataCell"];
    
    itemTable.scrollEnabled = NO;
    
    titleArray = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    
    titleArray = [NSMutableArray arrayWithObjects:@"Nombre:",@"Categoria",@"Cantidad:",@"Fecha salida:",@"Fecha Entregado:",nil];
    
    /*if ([item.date_in length] == 0) {
        item.date_in = @"No entregado";
    }
    */
    NSDictionary* name = @{@"name": @"Nombre", @"image": @"name100",@"content": self.item.componentName};
    NSDictionary* category = @{@"name": @"Categoria", @"image": self.item.categoryName, @"content": self.item.categoryName};
    NSDictionary* quantity = @{@"name": @"Cantidad", @"image": @"quantity100",@"content": self.item.quantity};
    NSDictionary* dateOut = @{@"name": @"Fecha salida", @"image": @"calendar100",@"content": self.date_out.date_title};
    NSDictionary* dateIn = @{@"name": @"Fecha Entregado", @"image": @"folder100",@"content": self.date_in.date_title};
    
    [dataArray addObject:name];
    [dataArray addObject:category];
    [dataArray addObject:quantity];
    [dataArray addObject:dateOut];
    [dataArray addObject:dateIn];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) btnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //historialItemDataCell
        LBHistorialItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historialItemDataCell" forIndexPath:indexPath];
    //NSDictionary* item = [[NSDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexPath.row]];
    cell.itemTitle.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.itemData.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    cell.itemImage.image = [UIImage imageNamed:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
    return cell;
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
