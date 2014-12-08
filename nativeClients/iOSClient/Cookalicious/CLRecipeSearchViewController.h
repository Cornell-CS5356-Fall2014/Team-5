//
//  CLRecipeSearchViewController.h
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLJournalEntryModel.h"


@class CLRecipeSearchViewController;

@protocol CLRecipeSearchViewControllerDelegate<NSObject>

@required
-(void)recipeSearchViewControllerDidAccept:(CLRecipeSearchViewController *)recipeSearchViewController;
@end

@interface CLRecipeSearchViewController : UIViewController

//@property (weak, nonatomic) CLJournalEntryModel *journalEntry;
//@property (nonatomic, strong) CLRecipeModel *recipeToReceive;
@property (weak, nonatomic) id <CLRecipeSearchViewControllerDelegate>delegate;
@property (nonatomic, strong) CLRecipeModel *selectedRecipe;

@end
