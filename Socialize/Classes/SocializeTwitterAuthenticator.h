//
//  SocializeTwitterAuthenticator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeServiceDelegate.h"
#import "SocializeTwitterAuthViewControllerDelegate.h"
#import "SocializeUIDisplay.h"
#import "SocializeAction.h"
#import "SocializeTwitterAuthOptions.h"
#import "SocializeThirdPartyAuthenticator.h"
#import "SocializeServiceDelegate.h"

@class Socialize;
@class SocializeTwitterAuthViewController;
@class SocializeUIDisplayProxy;
@class SocializeTwitterAuthOptions;

@interface SocializeTwitterAuthenticator : SocializeThirdPartyAuthenticator <SocializeTwitterAuthViewControllerDelegate, SocializeServiceDelegate>

+ (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                                  display:(id)display
                                  success:(void(^)())success
                                  failure:(void(^)(NSError *error))failure;

+ (void)authenticateViaTwitterWithOptions:(SocializeTwitterAuthOptions*)options
                             displayProxy:(SocializeUIDisplayProxy*)proxy
                                  success:(void(^)())success
                                  failure:(void(^)(NSError *error))failure;

@property (nonatomic, retain) SocializeTwitterAuthOptions *options;
@property (nonatomic, retain) SocializeTwitterAuthViewController *twitterAuthViewController;
@end
