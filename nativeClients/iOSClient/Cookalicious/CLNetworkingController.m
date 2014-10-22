//
//  CLNetworkingController.m
//  Cookalicious
//
//  Created by James Kizer on 10/21/14.
//  Copyright (c) 2014 SHJK-BuildingStartupSystems. All rights reserved.
//

#import "CLNetworkingController.h"
#import <AFNetworking.h>

static NSString *baseURLStringKey = @"BaseURL";
static NSUInteger defaultRetryCount = 3;

@interface CLNetworkingController()

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;


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
    //NSLog(@"%@", self.operationManager.)
    [self.operationManager POST:@"/auth/facebook/token" parameters:@{@"access_token" : authToken} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
            success(operation, responseObject);
//        if(complete)
//            complete(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        if (retryCount > 0)
//        {
//            NSLog(@"Retrying...");
//            requestBlock2(retryCount-1);
//        }
//        else
//        {
//            if(completionHandler)
//                completionHandler(UIBackgroundFetchResultFailed);
//        }
        
        if(failure)
            failure(operation, error);
        
    }];
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

@end
