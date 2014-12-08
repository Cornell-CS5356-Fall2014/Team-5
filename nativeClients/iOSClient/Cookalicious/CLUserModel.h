//
//  CLUserModel.h
//  Cookalicious
//
//  Created by James Kizer on 12/8/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLUserModel : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSArray *followers;
@property (strong, nonatomic) NSArray *following;

@end
