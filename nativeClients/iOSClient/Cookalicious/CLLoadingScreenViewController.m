//
//  CLLoadingScreenViewController.m
//  Cookalicious
//
//  Created by James Kizer on 10/20/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLLoadingScreenViewController.h"
#import "CLNetworkingController.h"
#import <FacebookSDK.h>
#import "CLLogInViewController.h"

@interface CLLoadingScreenViewController ()

@end

@implementation CLLoadingScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    NSLog(@"%@", FBSession.activeSession);
//    NSLog(@"%@", FBSession.activeSession.accessTokenData);
//    
//    [[CLNetworkingController sharedController] getUserPhotosOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [[CLNetworkingController sharedController] getUserPhotosOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [[CLNetworkingController sharedController] getUserPhotosOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//        
//    }];
    
    //[self checkForLogin];
    
}

-(void)checkForLogin
{
    //Check for authentication
    
    //check for valid facebook token and check refresh date
    //if there is a facebook token, check for authentication
    //if we are not authenticated, post the facebook token to server
    
    if(FBSession.activeSession.accessTokenData)
    {
        
        //check refresh date for access token
        //if
        NSLog(@"Token Expiration Date%@",FBSession.activeSession.accessTokenData.expirationDate);
        
        if([FBSession.activeSession.accessTokenData.expirationDate timeIntervalSinceNow] < 0)
        {
            //session is past expiration date
            //segue to log in view
            [self performSegueWithIdentifier:@"ShowFBLoginViewSegue" sender:nil];
            //[self presentLogInViewController];
        }
        
        else
        {
            
            [[CLNetworkingController sharedController] isloggedInOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]])
                {
                    //segue to home screen
                    [self performSegueWithIdentifier:@"ShowHomeViewSegueFromLoadingScreen" sender:nil];
                }
                else
                {
                    //post facebook token to server
                    [[CLNetworkingController sharedController] postFBAuthToken:FBSession.activeSession.accessTokenData.accessToken success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        //segue to home screen
                        [self performSegueWithIdentifier:@"ShowHomeViewSegueFromLoadingScreen" sender:nil];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        //some type of failure has occurred
                        
                    }];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //server failure
                
                
            }];
        }
    }
    
    //else, no FB token
    //segue to FB Login View
    else
    {
        //session is past expiration date
        //segue to log in view
        [self performSegueWithIdentifier:@"ShowFBLoginViewSegue" sender:nil];
        //[self presentLogInViewController];
    }
    
}

-(void)presentLogInViewController
{
    CLLogInViewController *logInVC = [[CLLogInViewController alloc] init];
    logInVC.completionBlock = ^(BOOL accepted){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:logInVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkForLogin];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFBLoginViewSegue"])
    {
        CLLogInViewController *logInVC = [segue destinationViewController];
        logInVC.cancelEnabled = NO;
        logInVC.completionBlock = ^(BOOL accepted){
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}

@end
