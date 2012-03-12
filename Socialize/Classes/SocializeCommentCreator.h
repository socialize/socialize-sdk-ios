//
//  SocializeCommentCreator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeAction.h"
#import "SocializeActivityCreator.h"
#import "SocializeComment.h"
#import "SocializeCommentOptions.h"

@interface SocializeCommentCreator : SocializeActivityCreator
+ (void)createComment:(id<SocializeComment>)comment
              options:(SocializeCommentOptions*)options
              display:(id)display
              success:(void(^)(id<SocializeComment>))success
              failure:(void(^)(NSError *error))failure;

@property (nonatomic, readonly) id<SocializeComment> comment;

@end
