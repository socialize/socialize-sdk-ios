//
//  SocializeLikeCreator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeActivityCreator.h"
#import "SocializeLike.h"
#import "SocializeLikeOptions.h"

@interface SocializeLikeCreator : SocializeActivityCreator
+ (void)createLike:(id<SocializeLike>)like
           options:(SocializeLikeOptions*)options
      displayProxy:(SocializeUIDisplayProxy*)displayProxy
           success:(void(^)(id<SocializeLike>))success
           failure:(void(^)(NSError *error))failure;

@property (nonatomic, readonly) id<SocializeLike> like;

@end
