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

@interface SZCommentUtils : NSObject

+ (void)showCommentsListWithViewController:(UIViewController*)viewController entity:(id<SZEntity>)entity completion:(void(^)())completion;

+ (void)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text shareOptions:(SZShareOptions*)shareOptions success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentWithId:(NSNumber*)commentId success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

+ (void)getCommentsByEntityWithEntityKey:(NSString*)entityKey success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsByUserWithUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsByUserAndEntityWithUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

@end
