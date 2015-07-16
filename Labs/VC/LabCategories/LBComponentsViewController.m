//
//  LBComponentsViewController.m
//  Labs
//
//  Created by Adriana Elizondo on 7/12/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "LBComponentsViewController.h"
#import "LBComponentTableViewCell.h"
#import "LBSearchResultsTableViewController.h"
#import "LBComponent.h"
#import "RequestHelper.h"
#import "UIImage+ImageEffects.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <pop/POP.h>

@interface LBComponentsViewController ()<UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSArray *components;
    LBSearchResultsTableViewController *searchResultsController;
}
@property CGFloat percentScrolled;
@property (weak, nonatomic) IBOutlet UITableView *componentsTableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;

@end

@implementation LBComponentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Register class for collection view cell
    UINib *nib = [UINib nibWithNibName:@"LBComponentTableViewCell" bundle: nil];
    [self.componentsTableView registerNib:nib forCellReuseIdentifier:@"componentCell"];
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startSearch)];
    self.navigationItem.rightBarButtonItem = searchBarButton;

    self.componentsTableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.7];
    
    //Get components from server
    [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%@?id_category_fk=%@", self.componentsURL, self.idCategory] response:^(id response, id error) {
        components = [[NSArray alloc] initWithArray:[LBComponent arrayOfModelsFromDictionaries:response]];
        [self.componentsTableView reloadData];
        [self startAnimation:NO repeatCount:0];
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [self pixelColorInImage:self.categoryImage.image atX:0 atY:0];
    [self startAnimation:YES repeatCount:HUGE_VALF];
}

-(void)startAnimation:(BOOL)reverses repeatCount:(int)count{
    POPSpringAnimation *scaleDownAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleDownAnimation.springBounciness = 15;
    scaleDownAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2,2)];
    scaleDownAnimation.autoreverses = reverses;
    scaleDownAnimation.repeatCount= count;
    [self.categoryImage.layer pop_addAnimation:scaleDownAnimation forKey:@"scaleDown"];
}

- (UIColor*)pixelColorInImage:(UIImage*)image atX:(int)x atY:(int)y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((image.size.width  * y) + x ) * 4; // 4 bytes per pixel
    
    UInt8 red   = data[pixelInfo + 0];
    UInt8 green = data[pixelInfo + 1];
    UInt8 blue  = data[pixelInfo + 2];
    UInt8 alpha = data[pixelInfo + 3];
    CFRelease(pixelData);
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha/255.0f];
}


#pragma mark - Start search
- (void)startSearch{
    searchResultsController = [[LBSearchResultsTableViewController alloc] init];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self presentViewController:self.searchController animated:YES completion:nil];
}


#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSArray *searchResults = [components copy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    searchResults = [searchResults filteredArrayUsingPredicate:predicate];
    
    // hand over the filtered results to our search results table
    LBSearchResultsTableViewController *tableController = (LBSearchResultsTableViewController *)self.searchController.searchResultsController;
    tableController.searchResults = searchResults;
    [tableController.tableView reloadData];
}

-(void)willDismissSearchController:(UISearchController *)searchController{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - Table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return components.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBComponentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"componentCell"];
    LBComponent *component = [components objectAtIndex:indexPath.row];
    cell.name.text = component.name;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.percentScrolled =  scrollView.contentOffset.y;
}


@end
