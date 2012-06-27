//
//  SocializeRichPushNotificationDisplayControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeRichPushNotificationDisplayControllerTests.h"

@implementation SocializeRichPushNotificationDisplayControllerTests
@synthesize richPushNotificationDisplayController = richPushNotificationDisplayController_;

- (id)createUUT {
    self.richPushNotificationDisplayController = [[[SocializeDirectURLNotificationDisplayController alloc] initWithUserInfo:nil] autorelease];
    
    return self.richPushNotificationDisplayController;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    self.richPushNotificationDisplayController = nil;
    
    [super tearDown];
}

- (void)testMainViewControllerNotNil {
    UIViewController *mainViewController = [self.richPushNotificationDisplayController mainViewController];
    GHAssertNotNil(mainViewController, @"view controller not defined");
}

@end
