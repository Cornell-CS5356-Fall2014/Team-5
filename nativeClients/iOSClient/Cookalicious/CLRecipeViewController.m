//
//  CLRecipeViewController.m
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLRecipeViewController.h"
#import "CLNetworkingController.h"

@interface CLRecipeViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *acceptButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *yieldsLabel;
@property (weak, nonatomic) IBOutlet UITextView *ingredientsTextView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;


@end

@implementation CLRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.recipe.title;
    self.time.text = [NSString stringWithFormat:@"Time: %@", self.recipe.totalTime];
    self.yieldsLabel.text = [NSString stringWithFormat:@"Yields %@", self.recipe.yield];
    
    __block NSString *ingredientString = @"";
    [self.recipe.ingredients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ingredientString = [ingredientString stringByAppendingString:[NSString stringWithFormat:@"%@\n", obj]];
        
    }];
    
    self.ingredientsTextView.text = ingredientString;
    
    [[CLNetworkingController sharedController] setImageOfImageView:self.photoImageView withURL:self.recipe.mediumImageURL];
    
    if(self.backOnly)
    {
        self.cancelButton.title = @"Back";
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)back:(UIBarButtonItem *)sender {
    
    if(sender == self.acceptButton)
        if(self.delegate)
            [self.delegate recipeViewControllerDidAccept:self];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)viewLink:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.recipe.linkURL]];

}

@end
