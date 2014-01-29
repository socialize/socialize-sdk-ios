//
//  SZUserProfileViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZUserProfileViewController.h"
#import "_SZUserProfileViewController.h"
#import "SZUserProfileViewControllerIOS6.h"
#import "UIDevice+VersionCheck.h"

@interface SZUserProfileViewController ()
@property (nonatomic, strong) id<SZUser> user;
@property (nonatomic, strong) _SZUserProfileViewController *profile;
@end

@implementation SZUserProfileViewController
@dynamic completionBlock;
@synthesize profile = _profile;
@synthesize user = _user;

//class cluster impl
//used for navbar as this class is a subclass of SZNavigationBar
+ (id)alloc {
    if([self class] == [SZUserProfileViewController class] &&
        [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [SZUserProfileViewControllerIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithUser:(id<SocializeUser>)user {
    if (self = [super init]) {
        self.user = user;
        [self pushViewController:self.profile animated:NO];
    }
    
    return self;
}

- (_SZUserProfileViewController*)profile {
    if (_profile == nil) {
        _profile = [[_SZUserProfileViewController alloc] initWithUser:self.user delegate:nil];
    }
    return _profile;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.profile;
}

@end
