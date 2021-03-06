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
#import <Colours/Colours.h>
#import "UINavigationController+Transparent.h"

@interface LBComponentsViewController ()<UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSArray *components;
    LBSearchResultsTableViewController *searchResultsController;
    UIColor *backgroundColor;
}
@property CGFloat percentScrolled;
@property BOOL shouldHide;
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

    
    //Get components from server
    [RequestHelper getRequestWithQueryString:[NSString stringWithFormat:@"%@?id_category_fk=%@", self.componentsURL, self.idCategory] response:^(id response, id error) {
        if (!error) {
            components = [[NSArray alloc] initWithArray:[LBComponent arrayOfModelsFromDictionaries:response]];
            [self.componentsTableView reloadData];
            [self.componentsTableView setSeparatorColor:[backgroundColor darken:.45f]];
            [self.categoryImage.layer removeAllAnimations];
        }
    }];
    
    [RACObserve(self, self.shouldHide) subscribeNext:^(NSNumber *percentScrolled) {
        NSLog(@"Refreshing: %@", percentScrolled);
        if ([percentScrolled boolValue]) {
            [self startAnimation:NO repeatCount:1 bounciness:5 spped:35 toSize:.5];
        }else{
            [self startAnimation:NO repeatCount:1 bounciness:5 spped:35 toSize:1];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage *image = [UIImage imageNamed:self.categoryName];
    backgroundColor = [self pixelColorInImage:image atX:1 atY:1];
    [self.categoryImage setImage:image];
    [self.componentsTableView setContentInset:UIEdgeInsetsMake(140, 0, 0, 0)];
  //  [self.navigationController presentNormalNavigationBar];
}

-(void)startAnimation:(BOOL)reverses repeatCount:(int)count bounciness:(int)bounciness spped:(int)speed toSize:(CGFloat)size{
    POPSpringAnimation *scaleDownAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleDownAnimation.springBounciness = bounciness;
    scaleDownAnimation.springSpeed = speed;
    scaleDownAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(size,size)];
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
    cell.name.textColor = [backgroundColor darken:.15f];
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
    
    if(scrollView.contentOffset.y <= 10)
    {
        //scrollup
        
        //[self.navigationController setNavigationBarHidden: YES animated:YES];
         self.navigationItem.titleView = nil;
        
        if (scrollView.contentOffset.y >= -110) {
            self.shouldHide = YES;
        }else{
            self.shouldHide = NO;
        }
    }
    else if(scrollView.contentOffset.y >= 10)
    {
        //scrolldown
        //[self.navigationController setNavigationBarHidden: NO animated:YES];
        UIImage *img = [UIImage imageNamed:self.categoryName];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [imgView setImage:img];
        // setContent mode aspect fit
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        self.navigationItem.titleView = imgView;
    }

}


@end
