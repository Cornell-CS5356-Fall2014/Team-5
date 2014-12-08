//
//  CLJournalEntryModel.m
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLJournalEntryModel.h"
//
//{
//    "user": "54434e8c99344308005ab3b2",
//    "title": "Test Title",
//    "detailText": "Test Description",
//    "recipeId": "JDSKUsldkfjsdfjhsdkjhffd",
//    "_id": "548398fb6af16408002eb28c",
//    "__v": 0,
//    "commentList": [],
//    "likerList": [],
//    "photoList": [
//                  "547257ed5354970800c3fd23"
//                  ],
//    "modifiedDate": "2014-12-07T00:02:03.252Z",
//    "createdDate": "2014-12-07T00:02:03.252Z"
//}

@implementation CLJournalEntryModel

-(instancetype) init
{
    self = [super init];
    if(self)
    {
        
        //_journalId= [dictionary objectForKey:@"_id"];
        //_userId = [dictionary valueForKeyPath:@"user"];
        //_detailText = [dictionary objectForKey:@"detailText"];
        //_recipeId = [dictionary valueForKeyPath:@"recipeId"];
        _commentList = [[NSArray alloc]init];
        _likerList = [[NSArray alloc]init];
        _photoList = [[NSArray alloc]init];
        _photoObjectArray = [[NSArray alloc]init];
        _createdDate = [NSDate date];
    }
    return self;
}

-(instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        
        _journalId= [dictionary objectForKey:@"_id"];
        _userId = [dictionary valueForKeyPath:@"user"];
        _detailText = [dictionary objectForKey:@"detailText"];
        _recipeId = [dictionary valueForKeyPath:@"recipeId"];
        _commentList = [[NSArray alloc]init];
        _likerList = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"likerList"]];
        _photoList = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"photoList"]];
        _createdDate = [[CLJournalEntryModel longDateFormatter] dateFromString:[dictionary objectForKey:@"createdDate"]];
    }
    return self;
}

-(NSDictionary *) newJournalEntryDictionary
{
    return @{ @"title" : self.title,
              @"detailText" : self.detailText,
              @"photoList" : self.photoList,
              @"recipeId" : self.recipeId };
}

-(void)addPhoto:(CLPhotoModel *)photo
{
    self.photoObjectArray = [self.photoObjectArray arrayByAddingObject:photo];
    self.photoList = [self.photoList arrayByAddingObject:photo.photoObjectID];
}

+(NSDateFormatter *)longDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return dateFormatter;
}


@end
