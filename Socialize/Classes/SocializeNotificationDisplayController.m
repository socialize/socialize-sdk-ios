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
@synthesize activityType = activityType_;
@synthesize activityID = activityID_;
@synthesize mainViewController = topViewController_;

- (void)dealloc {
    self.activityType = nil;
    self.activityID = nil;

    [super dealloc];
}

- (UIViewController*)mainViewController {
    NSAssert(NO, @"Not implemented");
    return nil;
}

@end
