//
//  SZShareUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"
#import "SZShareOptions.h"

@interface SZShareUtils : NSObject

+ (SZShareOptions*)userShareOptions;
+ (void)showShareDialogWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)(NSArray *shares))success __attribute__((deprecated("Please use showShareDialogWithViewController:entity:completion:cancellation:, instead")));

+ (void)showShareDialogWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)(NSArray *shares))completion cancellation:(void(^)())cancellation;
+ (void)showShareDialogWithViewController:(UIViewController*)viewController options:(SZShareOptions*)options entity:(id<SZEntity>)entity completion:(void(^)(NSArray *shares))completion cancellation:(void(^)())cancellation;

+ (void)shareViaEmailWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure __attribute__((deprecated("Please use shareViaEmailWithViewController:options:success:failure:, instead")));
+ (void)shareViaEmailWithViewController:(UIViewController*)viewController options:(SZShareOptions*)options entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure;
+ (BOOL)canShareViaEmail;
+ (void)shareViaSocialNetworksWithEntity:(id<SZEntity>)entity
                                networks:(SZSocialNetwork)networks
                                 options:(SZShareOptions*)options
                                 success:(void(^)(id<SZShare> share))success
                                 failure:(void(^)(NSError *error))failure;

+ (void)shareViaSMSWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure __attribute__((deprecated("Please use shareViaSMSWithViewController:options:success:failure:, instead")));
+ (void)shareViaSMSWithViewController:(UIViewController*)viewController options:(SZShareOptions*)options entity:(id<SZEntity>)entity success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure;
+ (BOOL)canShareViaSMS;

+ (void)getShareWithId:(NSNumber*)shareId success:(void(^)(id<SZShare> share))success failure:(void(^)(NSError *error))failure;
+ (void)getSharesWithIds:(NSArray*)shareIds success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;
+ (void)getSharesWithEntity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;
+ (void)getSharesWithUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;
+ (void)getSharesWithUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;
+ (void)getSharesByApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *shares))success failure:(void(^)(NSError *error))failure;

+ (NSString*)defaultMessageForShare:(id<SZShare>)share;
@end
