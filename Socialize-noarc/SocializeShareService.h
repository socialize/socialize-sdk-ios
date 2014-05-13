//
//  SocializeShareService.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"
#import "SocializeObjectFactory.h"
#import "SocializeEntity.h"
#import "SocializeRequest.h"
#import "SocializeService.h"

@protocol SocializeShare;
@protocol SZShare;

@interface SocializeShareService : SocializeService

- (void)createShareForEntityKey:(NSString*)key
                         medium:(SocializeShareMedium)medium
                           text:(NSString*)text;
- (void)createShareForEntity:(id<SocializeEntity>)entity
                      medium:(SocializeShareMedium)medium
                        text:(NSString*)text;
- (void)createShare:(id<SocializeShare>)share;
- (void)createShare:(id<SocializeShare>)share
            success:(void(^)(id<SZShare> share))success
            failure:(void(^)(NSError *error))failure;
- (void)createShare:(id<SocializeShare>)share
            success:(void(^)(id<SZShare> share))success
            failure:(void(^)(NSError *error))failure
       loopySuccess:(id)loopySuccess
       loopyFailure:(id)loopyFailure;
- (void)getSharesWithIds:(NSArray*)shareIds
                 success:(void(^)(NSArray *shares))success
                 failure:(void(^)(NSError *error))failure;
- (void)getShareWithId:(NSNumber*)shareId
               success:(void(^)(id<SZShare> share))success
               failure:(void(^)(NSError *error))failure;
- (void)getSharesForEntityKey:(NSString*)key
                        first:(NSNumber*)first
                         last:(NSNumber*)last
                      success:(void(^)(NSArray *shares))success
                      failure:(void(^)(NSError *error))failure;
- (void)getSharesWithFirst:(NSNumber*)first
                      last:(NSNumber*)last
                   success:(void(^)(NSArray *shares))success
                   failure:(void(^)(NSError *error))failure;
- (void)reportLoopyShare:(NSString *)shareText
                 channel:(NSString *)channel
                 success:(id)success
                 failure:(id)failure;
- (void)reportLoopySharelink:(NSString *)urlStr
                     channel:(NSString *)channel
                     success:(id)success
                     failure:(id)failure;

@end
