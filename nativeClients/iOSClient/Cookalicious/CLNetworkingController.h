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

-(void)postUserPhoto:(NSString*)name
               fName:(NSString *)fName
               image:(UIImage *)image
           OnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)isloggedInOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success

          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)clearSession;

-(void)downloadImageAtURL:(NSString *)urlString
                  success:(void (^)(NSURLResponse *response, UIImage *downloadedImage))success
                  failure:(void (^)(NSURLResponse *response, NSError *error))failure;
//-(void)setImageOfImageView:(UIImageView *)imageView
//             withURLString:(NSString *)urlString;

-(void)setImageOfImageView:(UIImageView *)imageView
               withImageId:(NSString *)imageId;

-(void)setImageOfImageView:(UIImageView *)imageView
               withURL:(NSString *)url;

-(void)getPhotos:(NSArray *)photoIds
       onSuccess:(void (^)(id responseObject))success

         failure:(void (^)())failure;

-(void)postNewJournalEntry:(NSDictionary *)journalEntryDictionary
                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)searchForRecipe:(NSString *)searchString
             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getRecipe:(NSString *)recipeId
             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getMeOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getUsersOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)followUser:(NSString *)userId
         onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)unfollowUser:(NSString *)userId
         onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getJournalEntriesOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getUser:(NSString *)userId
          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
