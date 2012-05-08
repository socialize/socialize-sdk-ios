//
//  SZShareUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

@interface SZShareUtils : NSObject

+ (void)showShareDialogWithViewController:(UIViewController*)viewController entity:(id<SocializeEntity>)entity;

+ (void)shareViaEmailWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure;

+ (void)shareViaSMSWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure;

+ (BOOL)canShareViaEmail;

+ (BOOL)canShareViaSMS;

+ (void)getShareWithId:(NSNumber*)shareId success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure;

+ (void)getSharesWithIds:(NSArray*)shareIds success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;

@end
