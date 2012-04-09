//
//  SocializeThirdPartyLinker.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeAction.h"
#import "SocializeAuthViewController.h"
#import "SocializeThirdPartyLinkOptions.h"

@interface SocializeThirdPartyLinker : SocializeAction <SocializeAuthViewControllerDelegate>
+ (void)linkToThirdPartyWithOptions:(SocializeThirdPartyLinkOptions*)options
                       displayProxy:(SocializeUIDisplayProxy*)displayProxy
                            success:(void(^)())success
                            failure:(void(^)(NSError *error))failure;

@end