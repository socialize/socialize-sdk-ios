//
//  SocializeFacebookAuthenticator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeAction.h"
#import "SocializeFacebookAuthOptions.h"
#import "SocializeThirdPartyAuthenticator.h"

@class SocializeFacebookAuthHandler;

@interface SocializeFacebookAuthenticator : SocializeThirdPartyAuthenticator
+ (void)authenticateViaFacebookWithOptions:(SocializeFacebookAuthOptions*)options
                                   display:(id)display
                                   success:(void(^)())success
                                   failure:(void(^)(NSError *error))failure;
+ (void)authenticateViaFacebookWithOptions:(id)options
                              displayProxy:(SocializeUIDisplayProxy*)proxy
                                   success:(void(^)())success
                                   failure:(void(^)(NSError *error))failure;

@property (nonatomic, retain) SocializeFacebookAuthOptions *options;
@property (nonatomic, retain) SocializeFacebookAuthHandler *facebookAuthHandler;
@property (nonatomic, assign) Class thirdParty;

@end
