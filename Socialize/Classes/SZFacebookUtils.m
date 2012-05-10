//
//  SZFacebookUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZFacebookUtils.h"
#import "SocializeThirdPartyFacebook.h"

@implementation SZFacebookUtils

+ (BOOL)isAvailable {
    return [SocializeThirdPartyFacebook available];
}

+ (BOOL)isLinked {
    return [SocializeThirdPartyFacebook isLinkedToSocialize];
}

@end
