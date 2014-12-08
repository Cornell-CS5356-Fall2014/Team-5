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

@interface CLNewJournalEntryViewController () <iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) CLJournalEntryModel *journalEntry;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *titleTextField;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *journalEntryDetailsTextField;
@property (weak, nonatomic) IBOutlet iCarousel *journalEntryPhotoCarousel;

@property (strong, nonatomic)UIView *addPhotoView;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;


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
    
    self.addPhotoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addIcon"]];
    
    self.postButton.enabled = NO;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.journalEntryPhotoCarousel reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel Methods



- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 1;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    return self.addPhotoView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}

- (IBAction)completeJournalEntry:(UIBarButtonItem *)sender {
    
    if (sender == self.cancelButton)
        [self.navigationController popViewControllerAnimated:YES];
    else if(sender == self.postButton)
    {
        NSDictionary *journalEntryDictionary = [self.journalEntry newJournalEntryDictionary];
        [[CLNetworkingController sharedController] postNewJournalEntry:journalEntryDictionary onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
