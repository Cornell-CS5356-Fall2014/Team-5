//
//  CLRecipeViewController.h
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecipeModel.h"
#import "CLJournalEntryModel.h"

@class CLRecipeViewController;

@protocol CLRecipeViewControllerDelegate<NSObject>

@required
-(void)recipeViewControllerDidAccept:(CLRecipeViewController *)recipeViewController;
@end


@interface CLRecipeViewController : UIViewController

@property (strong, nonatomic) CLRecipeModel *recipe;
@property (weak, nonatomic) id <CLRecipeViewControllerDelegate>delegate;
@property (nonatomic) BOOL backOnly;
//@property (strong, nonatomic) CLJournalEntryModel *journalEntry;

@end






