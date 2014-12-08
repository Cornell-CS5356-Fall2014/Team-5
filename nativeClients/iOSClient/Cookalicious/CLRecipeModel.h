//
//  CLRecipeModel.h
//  Cookalicious
//
//  Created by James Kizer on 12/7/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLRecipeModel : NSObject

@property (strong, nonatomic) NSString *recipeId;
@property (strong, nonatomic) NSString *title;
//@property (strong, nonatomic) NSNumber *timeInSeconds;
@property (strong, nonatomic) NSString *totalTime;
//@property (strong, nonatomic) NSNumber *servings;
@property (strong, nonatomic) NSString *yield;
@property (strong, nonatomic) NSArray *ingredients; //of NSString
@property (strong, nonatomic) NSString *smallImageURL;
@property (strong, nonatomic) NSString *mediumImageURL;
@property (strong, nonatomic) NSString *linkURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
