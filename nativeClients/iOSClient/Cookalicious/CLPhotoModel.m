//
//  CLPhotoModel.m
//  Cookalicious
//
//  Created by James Kizer on 10/22/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLPhotoModel.h"




NSString * const kOriginalPhotoURL=@"original";

@implementation CLPhotoModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        
        _photoObjectID = [dictionary objectForKey:@"_id"];
        _owningUserID = [dictionary objectForKey:@"user"];
        //_caption = [dictionary objectForKey:@"caption"];
        _createdDate = [[CLPhotoModel longDateFormatter] dateFromString:[dictionary objectForKey:@"created"]];
        //_filename = [dictionary objectForKey:@"filename"];
        _originalImageID = [dictionary objectForKey:@"original"];
        if([dictionary objectForKey:@"thumbnail"] && ![[dictionary objectForKey:@"thumbnail"] isKindOfClass:[NSNull class]])
            _thumbnailImageID = [dictionary objectForKey:@"thumbnail"];
        else
            _thumbnailImageID = @"";
    }
    return self;
}

+(NSDateFormatter *)longDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return dateFormatter;
}

@end

@implementation NSDictionary (CLPhotoModelExtensions)

- (id)photoModelFromDictionary
{
    return [[CLPhotoModel alloc]initWithDictionary:self];
                          
}

@end
