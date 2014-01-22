//
//  _SZUserProfileViewControllerIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/15/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "_SZUserProfileViewControllerIOS6.h"

@implementation _SZUserProfileViewControllerIOS6

- (UIImage *)defaultBackgroundImage {
    return [UIImage imageNamed:@"background_brushed_metal.png"];
}

- (UIImage *)defaultHeaderBackgroundImage {
    return [UIImage imageNamed:@"socialize-sectionheader-bg.png"];
}

- (UIImage*)defaultProfileImage {
    return [UIImage imageNamed:@"socialize-profileimage-large-default.png"];
}

- (UIImage*)defaultProfileBackgroundImage {
    return [UIImage imageNamed:@"socialize-profileimage-large-bg.png"];
}

- (void)setProfileImageFromImage:(UIImage*)image {
    if (image == nil) {
        self.profileImageView.image = nil;
    }
    else {
        self.profileImageView.image = image;
    }
}

@end
