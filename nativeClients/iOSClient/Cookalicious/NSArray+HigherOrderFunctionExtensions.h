//
//  NSArray+HigherOrderFunctionExtensions.h
//  Cookalicious
//
//  Created by James Kizer on 10/22/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HigherOrderFunctionExtensions)

-(instancetype) map:(SEL)aSelector;

@end
