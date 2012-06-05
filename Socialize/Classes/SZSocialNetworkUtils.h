//
//  SZSocialNetworkUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/16/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZDisplay.h"

@protocol SZSocialNetworkUtils <NSObject>
+ (BOOL)isAvailable;
+ (BOOL)isLinked;

+ (void)linkWithDisplay:(id<SZDisplay>)display success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
+ (void)unlink;

@end