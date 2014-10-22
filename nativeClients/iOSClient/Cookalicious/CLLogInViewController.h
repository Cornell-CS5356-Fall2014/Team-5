//
//  CLLogInViewController.h
//  Cookalicious
//
//  Created by James Kizer on 10/20/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void (^LogInVCCompletionBlock)(BOOL accepted);

@interface CLLogInViewController : UIViewController <FBLoginViewDelegate>

@property (nonatomic) BOOL cancelEnabled;
@property (strong, nonatomic) LogInVCCompletionBlock completionBlock;

@end
