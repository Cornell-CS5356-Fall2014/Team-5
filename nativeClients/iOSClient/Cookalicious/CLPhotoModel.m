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
        _photoObjectID = [NSNumber numberWithLongLong:[[dictionary objectForKey:@"_id"] longLongValue]];
        _owningUserID = [NSNumber numberWithLongLong:[[dictionary objectForKey:@"user._id"] longLongValue]];
        _caption = [dictionary objectForKey:@"caption"];
        _createdDate = [[CLPhotoModel longDateFormatter] dateFromString:[dictionary objectForKey:@"created"]];
        _filename = [dictionary objectForKey:@"filename"];
        
        NSArray *photoURLKeys = @[kOriginalPhotoURL];
        NSMutableDictionary *imageURLStringMutableDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *imagesDictionary = [dictionary objectForKey:@"image"];
        
        [photoURLKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString *keyString = [NSString stringWithFormat:@"%@.url", obj];
            
            //[imageURLStringMutableDictionary setObject:[[imagesDictionary objectForKey:obj] objectForKey:@"url"] forKey:obj];
            
            [imageURLStringMutableDictionary setObject:[imagesDictionary valueForKeyPath:keyString] forKey:obj];
        }];
        
        _imageURLStrings = [NSDictionary dictionaryWithDictionary:imageURLStringMutableDictionary];
        
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