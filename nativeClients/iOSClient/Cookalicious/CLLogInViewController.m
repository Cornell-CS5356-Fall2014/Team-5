//
//  CLLogInViewController.m
//  Cookalicious
//
//  Created by James Kizer on 10/20/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLLogInViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CLNetworkingController.h"

@interface CLLogInViewController () 


// In your view header file:
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end


@implementation CLLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin)];
    
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(acceptLogin)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)updateUI
{
    if(FBSession.activeSession.accessTokenData)
        self.navItem.rightBarButtonItem.enabled = YES;
    else
        self.navItem.rightBarButtonItem.enabled = NO;
    
    self.navItem.leftBarButtonItem.enabled = self.cancelEnabled;
}

-(void)cancelLogin
{
    assert(self.completionBlock);
    self.completionBlock(NO);
}

-(void)acceptLogin
{
    assert(self.completionBlock);
    self.completionBlock(YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




#pragma Mark - FBLoginView Delegate Methods
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.objectID;
    self.nameLabel.text = user.name;
    
    //Get Session and Token
    //Send to Server
    FBAccessTokenData *tokenData = FBSession.activeSession.accessTokenData;
    
    [[CLNetworkingController sharedController] postFBAuthToken:tokenData.accessToken success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self updateUI];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self updateUI];
        
    }];
    
    
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
    [[CLNetworkingController sharedController] clearSession];
    
    self.cancelEnabled = NO;
    
    [self updateUI];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    [self updateUI];
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


@end
