//
//  CLPhotoCaptureViewController.m
//  Cookalicious
//
//  Created by James Kizer on 10/18/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLPhotoCaptureViewController.h"
#import "CLNetworkingController.h"

@interface CLPhotoCaptureViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIImage *capturedImage;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadButton;


@end

@implementation CLPhotoCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        [toolbarItems removeObjectAtIndex:2];
        [self.toolBar setItems:toolbarItems animated:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;

    self.imagePickerController = imagePickerController;
    
    self.imagePickerController.hidesBottomBarWhenPushed = YES;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.capturedImage = image;
    [self updateUI];
    self.imagePickerController = nil;

    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)updateUI
{
    [self.imageView setImage:self.capturedImage];
    self.uploadButton.enabled = (self.capturedImage != nil);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.imagePickerController = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)uploadPhoto:(id)sender {
    
    [[CLNetworkingController sharedController] postUserPhoto:@"test photo" fName:@"testFileName" image:self.capturedImage OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.capturedPhoto = [[CLPhotoModel alloc]initWithDictionary:responseObject];
        
        if(self.delegate)
            [self.delegate photoCaptureViewControllerDidAccept:self];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}
- (IBAction)cancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
