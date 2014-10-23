//
//  NSArray+HigherOrderFunctionExtensions.m
//  Cookalicious
//
//  Created by James Kizer on 10/22/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "NSArray+HigherOrderFunctionExtensions.h"

@implementation NSArray (HigherOrderFunctionExtensions)


-(instancetype) map:(SEL)aSelector
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        @try {
            [mutableArray addObject:[obj performSelector:aSelector withObject:nil]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
        }
        
    }];
    return [NSArray arrayWithArray:mutableArray];
}

@end
