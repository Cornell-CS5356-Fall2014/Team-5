//
//  CLPhotoCaptureViewController.h
//  Cookalicious
//
//  Created by James Kizer on 10/18/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPhotoModel.h"

@class CLPhotoCaptureViewController;

@protocol CLPhotoCaptureViewControllerDelegate<NSObject>

@required
-(void)photoCaptureViewControllerDidAccept:(CLPhotoCaptureViewController *)photoCaptureViewController;
@end

@interface CLPhotoCaptureViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) id <CLPhotoCaptureViewControllerDelegate>delegate;
@property (strong, nonatomic) CLPhotoModel *capturedPhoto;

@end
