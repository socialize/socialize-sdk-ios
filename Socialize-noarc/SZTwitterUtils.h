//
//  SZTwitterUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"
#import "SZSocialNetworkUtils.h"

@interface SZTwitterUtils : NSObject <SZSocialNetworkUtils>

+ (BOOL)isAvailable;
+ (BOOL)isLinked;
+ (void)unlink;
+ (void)linkWithDisplay:(id<SZDisplay>)display success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)linkWithAccessToken:(NSString*)accessToken accessTokenSecret:(NSString*)accessTokenSecret success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
@end
