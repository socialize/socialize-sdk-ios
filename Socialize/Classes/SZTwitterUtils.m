//
//  SZTwitterUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZTwitterUtils.h"
#import "SocializeThirdPartyTwitter.h"

@implementation SZTwitterUtils

+ (BOOL)isAvailable {
    return [SocializeThirdPartyTwitter available];
}

+ (BOOL)isLinked {
    return [SocializeThirdPartyTwitter isLinkedToSocialize];
}

@end
