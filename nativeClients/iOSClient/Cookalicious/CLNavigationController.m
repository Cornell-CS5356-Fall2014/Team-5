//
//  CLNavigationController.m
//  Cookalicious
//
//  Created by James Kizer on 10/21/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLNavigationController.h"
#import "CLLogInViewController.h"

@interface CLNavigationController () <UINavigationControllerDelegate>

@end

@implementation CLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentLogInViewController
{
    [self performSegueWithIdentifier:@"PresentLogInViewController" sender:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"PresentLogInViewController"])
    {
        CLLogInViewController *logInVC = [segue destinationViewController];
        logInVC.cancelEnabled = YES;
        logInVC.completionBlock = ^(BOOL accepted){
            [self dismissViewControllerAnimated:YES completion:nil];
            if(accepted)
                [self popToRootViewControllerAnimated:YES];
        };
    }
    
}


@end
