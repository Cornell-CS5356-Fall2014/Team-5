//
//  CLNetworkingController.h
//  Cookalicious
//
//  Created by James Kizer on 10/21/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface CLNetworkingController : NSObject

+ (id)sharedController;
@property (nonatomic) NSUInteger retryCount;

-(void)postFBAuthToken:(NSString *)authToken
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getUserPhotosOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success

                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)isloggedInOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success

          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)clearSession;

-(void)downloadImageAtURL:(NSString *)urlString
                  success:(void (^)(NSURLResponse *response, UIImage *downloadedImage))success
                  failure:(void (^)(NSURLResponse *response, NSError *error))failure;
-(void)setImageOfImageView:(UIImageView *)imageView
             withURLString:(NSString *)urlString;

@end
