//
//  SocializeNotificationController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/10/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationDisplayController.h"

@implementation SocializeNotificationDisplayController
@synthesize delegate = delegate_;
@synthesize mainViewController = topViewController_;
@synthesize userInfo = userInfo_;

- (void)dealloc {
    self.userInfo = nil;
    [super dealloc];
}

- (id)initWithUserInfo:(NSDictionary *)userInfo {
    if (self = [super init]) {
        self.userInfo = userInfo;
    }
    
    return self;
}

- (UIViewController*)mainViewController {
    NSAssert(NO, @"Not implemented");
    return nil;
}

@end
