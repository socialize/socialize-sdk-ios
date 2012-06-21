//
//  SZUserProfileViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZUserProfileViewController.h"
#import "_SZUserProfileViewController.h"

@interface SZUserProfileViewController ()
@property (nonatomic, strong) id<SZUser> user;
@property (nonatomic, strong) _SZUserProfileViewController *profile;
@end

@implementation SZUserProfileViewController
@dynamic completionBlock;
@synthesize profile = _profile;
@synthesize user = _user;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.profile;
}

@end
