//
//  SZUserProfileViewControllerIOS7.m
//  Socialize
//
//  Created by David Jedeikin on 1/6/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZUserProfileViewControllerIOS7.h"
#import "SZNavigationControllerIOS7.h"

@implementation SZUserProfileViewControllerIOS7

- (id)initWithUser:(id<SZUser>)user {
    if (self = [super initWithUser:user]) {
        [SZNavigationControllerIOS7 initNavigationBar:self];
    }
    
    return self;
    
}

@end
