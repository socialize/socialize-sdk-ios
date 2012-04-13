//
//  SocializeUILikeCreator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeAction.h"
#import "SocializeUILikeOptions.h"
#import "SocializeAuthViewController.h"

@interface SocializeUILikeCreator : SocializeAction

+ (void)createLike:(id<SocializeLike>)like
           options:(SocializeUILikeOptions*)options
      displayProxy:(SocializeUIDisplayProxy*)displayProxy
           success:(void(^)(id<SocializeLike>))success
           failure:(void(^)(NSError *error))failure;

@property (nonatomic, copy) void (^likeSuccessBlock)(id<SocializeLike> like);
@property (nonatomic, retain) id<SocializeLike> like;

@end
