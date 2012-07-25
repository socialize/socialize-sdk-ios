//
//  SZCommentUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/19/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"
#import "SZShareOptions.h"
#import "SZCommentOptions.h"

@interface SZCommentUtils : NSObject

+ (SZCommentOptions*)userCommentOptions;

+ (void)showCommentsListWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)())completion;
+ (void)showCommentComposerWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)(id<SZComment> comment))completion cancellation:(void(^)())cancellation;

+ (void)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;
+ (void)addCommentWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;

+ (void)getCommentWithId:(NSNumber*)commentId success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

+ (void)getCommentsByEntity:(id<SZEntity>)entity success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsByUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

+ (void)getCommentsByApplicationWithFirst:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
@end
