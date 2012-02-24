//
//  SocializeFacebookWallPoster.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeFacebookWallPostOptions.h"
#import "SocializeAction.h"
#import "SocializeFacebookInterface.h"

@interface SocializeFacebookWallPoster : SocializeAction
+ (void)postToFacebookWallWithOptions:(SocializeFacebookWallPostOptions*)options
                              display:(id)display
                              success:(void(^)())success
                              failure:(void(^)(NSError *error))failure;
+ (void)postToFacebookWallWithOptions:(SocializeFacebookWallPostOptions*)options
                         displayProxy:(SocializeUIDisplayProxy*)proxy
                              success:(void(^)())success
                              failure:(void(^)(NSError *error))failure;

@property (nonatomic, retain) SocializeFacebookWallPostOptions *options;
@property (nonatomic, retain) SocializeFacebookInterface *facebookInterface;

@end
