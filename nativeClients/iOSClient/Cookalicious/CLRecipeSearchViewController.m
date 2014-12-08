//
//  CLRecipeSearchViewController.m
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLRecipeSearchViewController.h"
#import "CLRecipeModel.h"
#import "CLSearchResultsTableViewController.h"
#import "CLNetworkingController.h"
#import "CLRecipeViewController.h"

@interface CLRecipeSearchViewController () <UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate, CLRecipeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *searchResults; // Filtered search results
@property (nonatomic, strong) NSArray *recipes;

@property (nonatomic, strong) CLRecipeModel *recipeToPass;
@property (strong, nonatomic) IBOutlet UISearchController *searchController;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *acceptButton;

@property (nonatomic) BOOL accepted;




@end

@implementation CLRecipeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    CLSearchResultsTableViewController *searchResultsController = [[CLSearchResultsTableViewController alloc]init];
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    //self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.acceptButton.enabled = NO;
    
    //self.recipeToReceive = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUI
{
    self.acceptButton.enabled = (self.selectedRecipe != nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchResults count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Search Results Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"recipeName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *selectedRowDictionary = [self.searchResults objectAtIndex:indexPath.row];
    NSString *recipeId = [selectedRowDictionary objectForKey:@"id"];
    
    [[CLNetworkingController sharedController] getRecipe:recipeId onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.recipeToPass = [[CLRecipeModel alloc]initWithDictionary:(NSDictionary *)responseObject];
        [self performSegueWithIdentifier:@"Show Recipe" sender:nil];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    
}


#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
//    NSString *scope = nil;
//    
//    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
//    if (selectedScopeButtonIndex > 0) {
//        scope = [[Product deviceTypeNames] objectAtIndex:(selectedScopeButtonIndex - 1)];
//    }
//    
//    [self updateFilteredContentForProductName:searchString type:scope];
//    
//    if (self.searchController.searchResultsController) {
//        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
//        
//        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
//        vc.searchResults = self.searchResults;
//        [vc.tableView reloadData];
//    }
}



#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    NSString *searchString = searchBar.text;
    
    [[CLNetworkingController sharedController] searchForRecipe:searchString onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.searchResults = (NSArray *)responseObject;
        [self.searchController setActive:NO];
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.searchResults = @[];
        [self.searchController setActive:NO];
        [self.tableView reloadData];
        
    }];
    
    
    
}


#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName {
    
//    // Update the filtered array based on the search text and scope.
//    if ((productName == nil) || [productName length] == 0) {
//        // If there is no search string and the scope is "All".
//        if (typeName == nil) {
//            self.searchResults = [self.products mutableCopy];
//        } else {
//            // If there is no search string and the scope is chosen.
//            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
//            for (Product *product in self.products) {
//                if ([product.type isEqualToString:typeName]) {
//                    [searchResults addObject:product];
//                }
//            }
//            self.searchResults = searchResults;
//        }
//        return;
//    }
//    
//    
//    [self.searchResults removeAllObjects]; // First clear the filtered array.
//    
//    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
//     */
//    for (Product *product in self.products) {
//        if ((typeName == nil) || [product.type isEqualToString:typeName]) {
//            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
//            NSRange productNameRange = NSMakeRange(0, product.name.length);
//            NSRange foundRange = [product.name rangeOfString:productName options:searchOptions range:productNameRange];
//            if (foundRange.length > 0) {
//                [self.searchResults addObject:product];
//            }
//        }
//    }
}




#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[CLRecipeViewController class]])
    {
        CLRecipeViewController *recipeViewController = (CLRecipeViewController *)[segue destinationViewController];
        
        recipeViewController.recipe = self.recipeToPass;
        recipeViewController.delegate = self;
    }
}

-(void)recipeViewControllerDidAccept:(CLRecipeViewController *)recipeViewController
{
    self.selectedRecipe = recipeViewController.recipe;
}

- (IBAction)completeSearch:(id)sender {
    
    if(sender == self.acceptButton)
        if(self.delegate)
            [self.delegate recipeSearchViewControllerDidAccept:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
