//
//  CLJournalEntryModel.h
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLPhotoModel.h"
#import "CLRecipeModel.h"

@interface CLJournalEntryModel : NSObject

-(instancetype) init;
-(instancetype) initWithDictionary:(NSDictionary *)journalEntryDictionary;

-(NSDictionary *) newJournalEntryDictionary;

@property (strong, nonatomic) NSString *journalId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detailText;
@property (strong, nonatomic) NSString *recipeId;
@property (strong, nonatomic) CLRecipeModel *recipe;
@property (strong, nonatomic) NSArray *commentList; //of CLCommentModel
@property (strong, nonatomic) NSArray *likerList; //of NSString
@property (strong, nonatomic) NSArray *photoList; //of NSString
@property (strong, nonatomic) NSArray *photoObjectArray; //of CLPhotoModel
@property (strong, nonatomic) NSDate *createdDate;

-(void)addPhoto:(CLPhotoModel *)photo;

+(NSDateFormatter *)longDateFormatter;

@end
