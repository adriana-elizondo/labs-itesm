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

@interface LBComponentsViewController ()<UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSArray *components;
    LBSearchResultsTableViewController *searchResultsController;
}
@property CGFloat percentScrolled;
@property (weak, nonatomic) IBOutlet UITableView *componentsTableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation LBComponentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Register class for collection view cell
    UINib *nib = [UINib nibWithNibName:@"LBComponentTableViewCell" bundle: nil];
    [self.componentsTableView registerNib:nib forCellReuseIdentifier:@"componentCell"];
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startSearch)];
    self.navigationItem.rightBarButtonItem = searchBarButton;

    
    //Get components from server
    [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%@?id_category_fk=%@", self.componentsURL, self.idCategory] response:^(id response, id error) {
        components = [[NSArray alloc] initWithArray:[LBComponent arrayOfModelsFromDictionaries:response]];
        [self.componentsTableView reloadData];
    }];
    
      [self.componentsTableView setContentInset:UIEdgeInsetsMake(80, 0, 0, 0)];
      [self tableViewObserver];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)tableViewObserver{
    @weakify(self)
    [RACObserve(self, self.percentScrolled) subscribeNext:^(id percentScrolled) {
        @strongify(self);
        
        CGFloat fpercentScrolled = [percentScrolled floatValue];
        CGFloat scale = fminf(1.f, fmaxf(.4f, fpercentScrolled));
        CGFloat top = fminf(1.f, fmaxf(.0f, fpercentScrolled));
        
        self.categoryImage.alpha = fpercentScrolled * 2 - 1;
        self.categoryImage.transform = CGAffineTransformMakeScale(scale, scale);
        self.topConstraint.constant = self.topConstraint.constant - top;
    }];
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
    cell.textLabel.text = component.name;
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.percentScrolled =  scrollView.contentOffset.y;
}


@end
