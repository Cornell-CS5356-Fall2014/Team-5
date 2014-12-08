//
//  CLRecipeModel.m
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLRecipeModel.h"

@implementation CLRecipeModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _recipeId = [dictionary objectForKey:@"id"];
        _title = [dictionary objectForKey:@"name"];
        _totalTime = [dictionary objectForKey:@"totalTime"];
        _yield = [dictionary objectForKey:@"yield"];
        _ingredients = [dictionary objectForKey:@"ingredientLines"];
        _smallImageURL = [[[dictionary objectForKey:@"images"] objectAtIndex:0] objectForKey:@"hostedSmallUrl"];
        _mediumImageURL = [[[dictionary objectForKey:@"images"] objectAtIndex:0] objectForKey:@"hostedMediumUrl"];
        _linkURL = [[dictionary objectForKey:@"source"] objectForKey:@"sourceRecipeUrl"];
//        _journalId= [dictionary objectForKey:@"_id"];
//        _userId = [dictionary valueForKeyPath:@"user"];
//        _detailText = [dictionary objectForKey:@"detailText"];
//        _recipeId = [dictionary valueForKeyPath:@"recipeId"];
//        _commentList = [[NSArray alloc]init];
//        _likerList = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"likerList"]];
//        _photoList = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"photoList"]];
//        _createdDate = [[CLJournalEntryModel longDateFormatter] dateFromString:[dictionary objectForKey:@"createdDate"]];
    }
    return self;
}

@end
