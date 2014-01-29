//
//  SZUserProfileViewControllerIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/6/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZUserProfileViewControllerIOS6.h"
#import "SZNavigationControllerIOS6.h"

@implementation SZUserProfileViewControllerIOS6

//navbar impl is set here, as this is a subclass of SZNavigationController
- (id)initWithUser:(id<SZUser>)user {
    if (self = [super initWithUser:user]) {
        [SZNavigationControllerIOS6 initNavigationBar:self];
    }
    
    return self;

}

@end
