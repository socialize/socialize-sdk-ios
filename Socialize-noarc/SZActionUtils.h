//
//  SZActionUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

@interface SZActionUtils : NSObject

+ (void)getActionsByApplicationWithStart:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *actions))success failure:(void(^)(NSError *error))failure;
+ (void)getActionsByUser:(id<SZUser>)user start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *actions))success failure:(void(^)(NSError *error))failure;
+ (void)getActionsByEntity:(id<SZEntity>)entity start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *actions))success failure:(void(^)(NSError *error))failure;
+ (void)getActionsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity start:(NSNumber*)start end:(NSNumber*)end success:(void(^)(NSArray *actions))success failure:(void(^)(NSError *error))failure;

@end
