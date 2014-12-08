//
//  CLNewJournalEntryViewController.m
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLNewJournalEntryViewController.h"
#import "CLJournalEntryModel.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "iCarousel.h"
#import "CLNetworkingController.h"
#import "CLRecipeSearchViewController.h"
#import "CLRecipeModel.h"
#import "CLPhotoCaptureViewController.h"

@interface CLNewJournalEntryViewController () <iCarouselDataSource, iCarouselDelegate, CLRecipeSearchViewControllerDelegate, CLPhotoCaptureViewControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) CLJournalEntryModel *journalEntry;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *titleTextField;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *journalEntryDetailsTextField;
@property (weak, nonatomic) IBOutlet iCarousel *journalEntryPhotoCarousel;

@property (strong, nonatomic)UIImageView *addPhotoView;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;


@end

@implementation CLNewJournalEntryViewController


-(CLJournalEntryModel *)journalEntry
{
    if(!_journalEntry) _journalEntry = [[CLJournalEntryModel alloc]init];
    return _journalEntry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.journalEntryDetailsTextField.placeholder = @"Journal Entry Details";
    
    self.journalEntryPhotoCarousel.type = iCarouselTypeLinear;
    
    //self.addPhotoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addIcon"]];
    self.addPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)];
    self.addPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    self.addPhotoView.image = [UIImage imageNamed:@"addIcon"];
    
    self.postButton.enabled = NO;
    
    self.journalEntryDetailsTextField.delegate = self;
    
}

-(void)updateUI
{
    if(!self.journalEntry.recipe)
        self.recipeNameLabel.text = @"No Recipe Selected";
    else
        self.recipeNameLabel.text = self.journalEntry.recipe.title;
    
    self.postButton.enabled = [self passesValidations];
}

-(BOOL)passesValidations
{
    return (self.journalEntry.recipe != nil) && ([self.titleTextField.text length] > 0) && ([self.journalEntryDetailsTextField.text length] > 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
    
    [self.journalEntryPhotoCarousel reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] > 0)
        [self updateUI];
}

#pragma mark - iCarousel Methods



- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSUInteger numberOfPhotos = [self.journalEntry.photoObjectArray count] + ((self.journalEntry.recipe != nil)? 1 : 0) + 1;
    return numberOfPhotos;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (index < [self.journalEntry.photoObjectArray count])
    {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TestImage"]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"TestImage"];
        CLPhotoModel *photo = [self.journalEntry.photoObjectArray objectAtIndex:index];
        [[CLNetworkingController sharedController] setImageOfImageView:imageView withImageId:photo.originalImageID];
        
        return imageView;
    }
    else
    {
        if (self.journalEntry.recipe)
        {
            if (index == [self.journalEntry.photoObjectArray count])
            {
//                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TestImage"]];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.image = [UIImage imageNamed:@"TestImage"];
                [[CLNetworkingController sharedController] setImageOfImageView:imageView withURL:self.journalEntry.recipe.smallImageURL];
                
                return imageView;
                
            }
            else
                return self.addPhotoView;
        }
        else
            return self.addPhotoView;
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if ( index == ([self numberOfItemsInCarousel:carousel] - 1))
        [self performSegueWithIdentifier:@"Photo Picker Segue" sender:nil];
}

- (IBAction)completeJournalEntry:(UIBarButtonItem *)sender {
    
    if (sender == self.cancelButton)
        [self.navigationController popViewControllerAnimated:YES];
    else if(sender == self.postButton)
    {
        self.journalEntry.title = self.titleTextField.text;
        self.journalEntry.detailText = self.journalEntryDetailsTextField.text;

        NSDictionary *journalEntryDictionary = [self.journalEntry newJournalEntryDictionary];
        [[CLNetworkingController sharedController] postNewJournalEntry:journalEntryDictionary onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }
    
}

-(void)recipeSearchViewControllerDidAccept:(CLRecipeSearchViewController *)recipeSearchViewController
{
    self.journalEntry.recipe = recipeSearchViewController.selectedRecipe;
    self.journalEntry.recipeId = recipeSearchViewController.selectedRecipe.recipeId;
    [self.journalEntryPhotoCarousel reloadData];
}

-(void)photoCaptureViewControllerDidAccept:(CLPhotoCaptureViewController *)photoCaptureViewController
{
    self.journalEntry.photoList = [self.journalEntry.photoList arrayByAddingObject:photoCaptureViewController.capturedPhoto.photoObjectID];
    
    self.journalEntry.photoObjectArray = [self.journalEntry.photoObjectArray arrayByAddingObject:photoCaptureViewController.capturedPhoto];
    [self.journalEntryPhotoCarousel reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[CLRecipeSearchViewController class]])
    {
        CLRecipeSearchViewController *recipeSearchViewController = (CLRecipeSearchViewController *)[segue destinationViewController];

        recipeSearchViewController.delegate = self;
    }
    
    else if ([[segue destinationViewController] isKindOfClass:[CLPhotoCaptureViewController class]])
    {
        CLPhotoCaptureViewController *photoCaptureViewController = (CLPhotoCaptureViewController *)[segue destinationViewController];
        
        photoCaptureViewController.delegate = self;
    }
}


@end
