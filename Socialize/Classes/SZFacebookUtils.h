//
//  SZFacebookUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

@interface SZFacebookUtils : NSObject

+ (BOOL)isAvailable;
+ (BOOL)isLinked;
+ (void)linkToFacebookWithViewController:(UIViewController*)viewController success:(void(^)(id<SZFullUser>))success failure:(void(^)(NSError *error))failure;
@end
