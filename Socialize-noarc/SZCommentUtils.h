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
#import "SZDisplay.h"

@interface SZCommentUtils : NSObject

+ (SZCommentOptions*)userCommentOptions;

+ (void)showCommentsListWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity completion:(void(^)())completion;
+ (void)showCommentComposerWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;

+ (void)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options networks:(SZSocialNetwork)networks success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;
+ (void)addCommentWithDisplay:(id<SZDisplay>)display entity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;

+ (void)getCommentWithId:(NSNumber*)commentId success:(void(^)(id<SZComment> comment))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsWithIds:(NSArray*)commentIds success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

+ (void)getCommentsByEntityWithEntityKey:(NSString*)entityKey success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsByUserWithUser:(id<SZUser>)user first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;
+ (void)getCommentsByUserAndEntityWithUser:(id<SZUser>)user entity:(id<SZEntity>)entity first:(NSNumber*)first last:(NSNumber*)last success:(void(^)(NSArray *comments))success failure:(void(^)(NSError *error))failure;

@end
