//
//  CLNetworkingController.m
//  Cookalicious
//
//  Created by James Kizer on 10/21/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLNetworkingController.h"
#import <AFNetworking.h>
#import "CLPhotoModel.h"
#import <UIKit+AFNetworking.h>
#import <AFNetworking+PromiseKit.h>
#import <PromiseKit.h>

static NSString *baseURLStringKey = @"BaseURL";
static NSUInteger defaultRetryCount = 3;
static NSString *cImagesPath = @"/images";

@interface CLNetworkingController()

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (strong, nonatomic) AFHTTPRequestOperationManager *imageOperationManger;


@end

@implementation CLNetworkingController

+ (id)sharedController {
    static CLNetworkingController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

-(id)init{
    self = [super init];
    if (self) {
        
        NSString *baseURLString = [[[NSBundle mainBundle] objectForInfoDictionaryKey:baseURLStringKey] copy];
        
        self.operationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:baseURLString]];
        self.operationManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer]]];
        self.operationManager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        self.imageOperationManger = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:baseURLString]];
        self.imageOperationManger.responseSerializer = [AFImageResponseSerializer serializer];
        self.operationManager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        self.retryCount = defaultRetryCount;
        
        //[self.operationManager.reachabilityManager startMonitoring];
        
        //since endpoints return mix of JSON and text, need compound serializer
        //note that this AFCompoundResponseSerializer tries AFJSONResponseSerializer
        //then AFHTTPResponseSerializer behavior.
        //self.operationManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer]]];
        
        
    }
    
    return self;
}

-(void)postFBAuthToken:(NSString *)authToken
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager POST:@"/auth/facebook/token" parameters:@{@"access_token" : authToken} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)getPhotos:(NSArray *)photoIds
      onSuccess:(void (^)(id responseObject))success

        failure:(void (^)())failure
{
    //NSLog(@"Cookies: %@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.operationManager.baseURL]);
    
    __block NSMutableArray *promiseArray = [[NSMutableArray alloc]init];
    __block NSMutableArray *photoObjectArray = [[NSMutableArray alloc]init];
    
    [photoIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        PMKPromise *promise = [self.operationManager GET:[NSString stringWithFormat:@"/photos/%@", obj] parameters:nil].then(^(id responseObject, AFHTTPRequestOperation *operation){
            [photoObjectArray addObject:responseObject];
        }).catch(^(NSError *error){
            NSLog(@"error happened: %@", error.localizedDescription);
        });
        
        [promiseArray addObject:promise];
        
    }];
    
    [PMKPromise when:promiseArray].then(^(){
        if([photoObjectArray count] == [photoIds count])
        {
            if(success)
                success(photoObjectArray);
        }
        else
            if(failure)
                failure();
    });
}

-(void)getUserPhotosOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success

                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //NSLog(@"Cookies: %@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.operationManager.baseURL]);
    [self.operationManager GET:@"/photos" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)postUserPhoto:(NSString*)name
               fName:(NSString *)fName
               image:(UIImage *)image
           OnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"name": name, @"filename": fName};
    NSData *imageData = UIImagePNGRepresentation(image);
    //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    [self.operationManager POST:@"/photos" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:imageData name:@"photo"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(failure)
            failure(operation, error);
    }];
}


-(void)isloggedInOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success

                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager GET:@"/loggedin" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)clearSession
{
    //NSHTTPCookie *cookieToDelete = nil;
    [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSHTTPCookie *cookie = (NSHTTPCookie *)obj;
        
        if([cookie.name isEqualToString: @"connect.sid"])
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            *stop = YES;
        }
    }];
}


-(void)downloadImageAtURL:(NSString *)urlString
                   success:(void (^)(NSURLResponse *response, UIImage *downloadedImage))success
                   failure:(void (^)(NSURLResponse *response, NSError *error))failure
{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.operationManager.baseURL, urlString]  ];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDownloadTask *downloadTask = [manager.session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                        // this handler is not executing on the main queue, so we can't do UI directly here
                                                        if (!error)
                                                        {
                                                            UIImage *image = nil;
                                                            if ([request.URL isEqual:URL]) {
                                                                // UIImage is an exception to the "can't do UI here"
                                                                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                                                                // but calling "self.image =" is definitely not an exception to that!
                                                                // so we must dispatch this back to the main queue
                                                            }
                                                            
                                                            if(success)
                                                                success(response, image);
                                                            
                                                        }
                                                        else
                                                            if(failure)
                                                                failure(response, error);
                                                    }];
    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
//                                                                     progress:nil
//                                                                  destination:nil
//                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//                                                                // this handler is not executing on the main queue, so we can't do UI directly here
//                                                                if (!error)
//                                                                {
//                                                                    UIImage *image = nil;
//                                                                    if ([request.URL isEqual:URL]) {
//                                                                        // UIImage is an exception to the "can't do UI here"
//                                                                        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:filePath]];
//                                                                        // but calling "self.image =" is definitely not an exception to that!
//                                                                        // so we must dispatch this back to the main queue
//                                                                    }
//                                                                    
//                                                                    if(success)
//                                                                        success(response, image);
//                                                                    
//                                                                }
//                                                                else
//                                                                    if(failure)
//                                                                        failure(response, error);
//    }];
    
    [downloadTask resume];
}


//-(void)setImageOfImageView:(UIImageView *)imageView
//             withURLString:(NSString *)urlString
//{
//    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.operationManager.baseURL, urlString]]];
//}

-(void)setImageOfImageView:(UIImageView *)imageView
             withImageId:(NSString *)imageId
{
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", self.operationManager.baseURL, cImagesPath, imageId]]];
}

-(void)setImageOfImageView:(UIImageView *)imageView
                   withURL:(NSString *)url
{
    [imageView setImageWithURL:[NSURL URLWithString:url]];
}

-(void)postNewJournalEntry:(NSDictionary *)journalEntryDictionary
                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure

{
    
    [self.operationManager POST:@"/journalEntries" parameters:journalEntryDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
    
}

-(void)searchForRecipe:(NSString *)searchString
             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [self.operationManager POST:@"/recipes/search" parameters:@{@"query" : searchString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *jsonParsingError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonParsingError];
        
        if (jsonParsingError) {
            NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
            if(failure)
                failure(operation, jsonParsingError);
        } else {
            NSLog(@"OBJECT: %@", [object class]);
            NSArray *resultsArray = [(NSDictionary *)object objectForKey:@"matches"];
            if(success)
                success(operation, resultsArray);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
    
}

-(void)getRecipe:(NSString *)recipeId
       onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager GET:[NSString stringWithFormat:@"/recipes/%@", recipeId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *jsonParsingError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonParsingError];
        
        
        
        if (jsonParsingError) {
            NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
            if(failure)
                failure(operation, jsonParsingError);
        } else {
            NSLog(@"OBJECT: %@", [object class]);
            //NSDictionary *result = [(NSDictionary *)object objectForKey:@"matches"];
            if(success)
                success(operation, object);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)getMeOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager GET:@"/users/me" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)getUsersOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager GET:@"/users" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)followUser:(NSString *)userId
         onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager POST:@"/following" parameters:@{@"userId" : userId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)unfollowUser:(NSString *)userId
            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager DELETE:@"/following" parameters:@{@"userId" : userId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)getJournalEntriesOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager GET:@"/journalEntries" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

-(void)getUser:(NSString *)userId
     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operationManager GET:[NSString stringWithFormat:@"/users/%@", userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation, error);
        
    }];
}

@end
