//
//  CLSearchResultsTableViewController.m
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLSearchResultsTableViewController.h"

@interface CLSearchResultsTableViewController ()

@end

@implementation CLSearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
//    Product *product = [self.searchResults objectAtIndex:indexPath.row];
//    
//    cell.textLabel.text = product.name;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Product *product = [self.searchResults objectAtIndex:indexPath.row];
//    DetailViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
//    self.presentingViewController.navigationItem.title = @"Search";
//    vc.product = product;
//    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}

@end
