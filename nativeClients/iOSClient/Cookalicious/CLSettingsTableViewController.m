//
//  CLSettingsTableViewController.m
//  Cookalicious
//
//  Created by James Kizer on 12/8/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLSettingsTableViewController.h"
#import "CLUserModel.h"
#import "CLNetworkingController.h"

@interface CLSettingsTableViewController ()

@property (strong, nonatomic) CLUserModel *me;
@property (strong, nonatomic) NSArray *allOtherUsers;
@property (strong, nonatomic) NSArray *allOtherUserIds;

@end

@implementation CLSettingsTableViewController

-(NSArray *)allOtherUsers
{
    if(!_allOtherUsers) _allOtherUsers = [[NSArray alloc]init];
    return _allOtherUsers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.userInteractionEnabled = NO;
    
    [[CLNetworkingController sharedController] getMeOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.me = [[CLUserModel alloc]init];
        self.me.userId = [responseObject objectForKey:@"_id"];
        self.me.username = [responseObject objectForKey:@"username"];
        self.me.followers = [responseObject objectForKey:@"followers"];
        self.me.following = [responseObject objectForKey:@"following"];
        NSString *myId = self.me.userId;
        
        [[CLNetworkingController sharedController] getUsersOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            __block NSMutableArray *userArray = [[NSMutableArray alloc]init];
            __block NSMutableArray *userIdArray = [[NSMutableArray alloc]init];
            [(NSArray *)responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if(![[obj objectForKey:@"_id"] isEqualToString:myId])
                {
                    CLUserModel *user = [[CLUserModel alloc]init];
                    user.userId = [obj objectForKey:@"_id"];
                    user.username = [obj objectForKey:@"username"];
                    user.followers = [obj objectForKey:@"followers"];
                    user.following = [obj objectForKey:@"following"];
                    [userArray addObject:user];
                    [userIdArray addObject:user.userId];
                }
                
                
            }];
            
            self.allOtherUsers = [NSArray arrayWithArray:userArray];
            self.allOtherUserIds = [NSArray arrayWithArray:userIdArray];
            
            [self.tableView reloadData];
            
            self.tableView.userInteractionEnabled = YES;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            self.tableView.userInteractionEnabled = YES;
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.tableView.userInteractionEnabled = YES;
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.allOtherUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"User Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    CLUserModel *user = [self.allOtherUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if([self.me.following containsObject:user.userId])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CLUserModel *user = [self.allOtherUsers objectAtIndex:indexPath.row];
    
    self.tableView.userInteractionEnabled = NO;
    
    if([self.me.following containsObject:user.userId])
    {
        [[CLNetworkingController sharedController] unfollowUser:user.userId onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.me.following];
            [newArray removeObject:user.userId];
            self.me.following = [NSArray arrayWithArray:newArray];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            self.tableView.userInteractionEnabled = YES;
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
           self.tableView.userInteractionEnabled = YES;
            
        }];
    }
    else
    {
        [[CLNetworkingController sharedController] followUser:user.userId onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.me.following];
            [newArray addObject:user.userId];
            self.me.following = [NSArray arrayWithArray:newArray];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            self.tableView.userInteractionEnabled = YES;
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            self.tableView.userInteractionEnabled = YES;
            
        }];
    }
    
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
