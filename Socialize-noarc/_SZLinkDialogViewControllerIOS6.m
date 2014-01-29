//
//  _SZLinkDialogViewControllerIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/14/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "_SZLinkDialogViewControllerIOS6.h"

@implementation _SZLinkDialogViewControllerIOS6

- (UIImage *)facebookIcon:(BOOL)enabled {
    return enabled ?
    [UIImage imageNamed:@"socialize-authorize-facebook-enabled-icon.png"] :
    [UIImage imageNamed:@"socialize-authorize-facebook-disabled-icon.png"];
}

- (UIImage *)twitterIcon:(BOOL)enabled {
    return enabled ?
    [UIImage imageNamed:@"socialize-authorize-twitter-enabled-icon.png"] :
    [UIImage imageNamed:@"socialize-authorize-twitter-disabled-icon.png"];
}

- (UIImage *)callOutArrow {
    return [UIImage imageNamed:@"socialize-activity-call-out-arrow.png"];
}

- (UIImage *)authorizeUserIcon {
    return [UIImage imageNamed:@"socialize-authorize-user-icon.png"];
}

@end
