//
//  CLPhotoModel.h
//  Cookalicious
//
//  Created by James Kizer on 10/22/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const kOriginalPhotoURL;

@interface CLPhotoModel : NSObject

@property (strong, nonatomic) NSNumber *photoObjectID;
@property (strong, nonatomic) NSNumber *owningUserID;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSDictionary *imageURLStrings;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+(NSDateFormatter *)longDateFormatter;
@end


@interface NSDictionary (CLPhotoModelExtensions)

- (id)photoModelFromDictionary;
  
@end