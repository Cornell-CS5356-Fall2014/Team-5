
//
//  CLFeedCollectionViewController.m
//  Cookalicious
//
//  Created by James Kizer on 10/22/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLFeedCollectionViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CLNetworkingController.h"
#import "CLPhotoModel.h"
#import "NSArray+HigherOrderFunctionExtensions.h"
#import <UIImageView+AFNetworking.h>


@interface CLFeedCollectionViewController () <CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet CHTCollectionViewWaterfallLayout *waterfallLayout;

@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (strong, nonatomic) NSArray *arrayOfPhotoObjects;
@property (strong, nonatomic) NSMutableArray *arrayOfImages;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;


@end

@implementation CLFeedCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.title = @"The Food Feed";
    
//    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self.navigationController action:@selector(presentLogInViewController)];
//    
//    self.navigationItem.rightBarButtonItem = logoutItem;
    
    self.logoutButton.target = self.navigationController;
    self.logoutButton.action = @selector(presentLogInViewController);
    
//    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:<#(SEL)#>];
//    self.navigationItem.leftBarButtonItem = cameraItem;
//    
//    self.navigationItem.hidesBackButton = YES;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.waterfallLayout.columnCount = 1;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    //[self loadPhotos:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadPhotos:nil];
}

-(void)loadPhotos:(void (^)(void))completion
{
    [[CLNetworkingController sharedController] getUserPhotosOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject isKindOfClass:[NSArray class]])
        {
            UIImage *placeHolderImage = [UIImage imageNamed:@"TestImage"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [(NSArray *)responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [self.arrayOfImages addObject:placeHolderImage];
                [self.imageViewArray addObject:[[UIImageView alloc] initWithImage:placeHolderImage]];
                
                [tempArray addObject:[[CLPhotoModel alloc] initWithDictionary:(NSDictionary *)obj]];
                
            }];
            self.arrayOfPhotoObjects = [NSArray arrayWithArray:tempArray];
            
            [self.arrayOfPhotoObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                CLPhotoModel *photo = (CLPhotoModel *)obj;
                [[CLNetworkingController sharedController] setImageOfImageView:[self.imageViewArray objectAtIndex:idx] withURLString: [photo.imageURLStrings objectForKey:kOriginalPhotoURL]];
                
            }];
            
            [self.collectionView reloadData];
        }
        
        if (completion)
            completion();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (completion)
            completion();
        
    }];
}

-(NSArray *)arrayOfPhotoObjects
{
    if(!_arrayOfPhotoObjects) _arrayOfPhotoObjects = [[NSArray alloc]init];
    return _arrayOfPhotoObjects;
}

-(NSMutableArray *)arrayOfImages
{
    if(!_arrayOfImages) _arrayOfImages = [[NSMutableArray alloc]init];
    return _arrayOfImages;
}

-(NSMutableArray *)imageViewArray
{
    if(!_imageViewArray) _imageViewArray = [[NSMutableArray alloc]init];
    return _imageViewArray;
}


- (CGSize)sizeForCells
{
    CGFloat width = (self.collectionView.bounds.size.width / self.waterfallLayout.columnCount)-10;
    return CGSizeMake(width, width);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPhotoObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Configure the cell
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.arrayOfImages objectAtIndex:indexPath.row]];
    UIImageView *imageView = [self.imageViewArray objectAtIndex:indexPath.row];
    [imageView removeFromSuperview];
    // Scale with fill for contents when we resize.
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Scale the imageview to fit inside the contentView with the image centered:
    CGRect imageViewFrame = CGRectMake(0.f, 0.f, CGRectGetMaxX(cell.contentView.bounds), CGRectGetMaxY(cell.contentView.bounds));
    imageView.frame = imageViewFrame;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    
    return cell;
}



#pragma mark <UICollectionViewDelegate>
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark <CHTCollectionViewDelegateWaterfallLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self sizeForCells];
}

@end
