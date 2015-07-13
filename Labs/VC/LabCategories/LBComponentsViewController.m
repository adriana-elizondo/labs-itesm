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

@interface LBComponentsViewController ()<UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSArray *components;
    LBSearchResultsTableViewController *searchResultsController;
}
@property (weak, nonatomic) IBOutlet UITableView *componentsTableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@end

@implementation LBComponentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Register class for collection view cell
    UINib *nib = [UINib nibWithNibName:@"LBComponentTableViewCell" bundle: nil];
    [self.componentsTableView registerNib:nib forCellReuseIdentifier:@"componentCell"];

    [self setUpSearchController];
    
    //Get components from server
    [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%@?id_category_fk=%@", self.componentsURL, self.idCategory] response:^(id response, id error) {
        components = [[NSArray alloc] initWithArray:[LBComponent arrayOfModelsFromDictionaries:response]];
        [self.componentsTableView reloadData];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.searchBar.hidden = YES;
}

-(void)setUpSearchController{
    searchResultsController = [[LBSearchResultsTableViewController alloc] init];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    
    searchResultsController.tableView.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self;
    
    self.componentsTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
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
    cell.textLabel.text = component.name;
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
