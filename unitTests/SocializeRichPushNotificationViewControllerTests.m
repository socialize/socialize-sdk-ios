//
//  SocializeRichPushNotificationViewControllerTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeRichPushNotificationViewControllerTests.h"

@implementation SocializeRichPushNotificationViewControllerTests
@synthesize richPushNotificationViewController;

+ (SocializeBaseViewController*)createController {
    return [[[SocializeRichPushNotificationViewController alloc] init] autorelease];
}

- (void)tearDown {
    [super tearDown];
    
    self.richPushNotificationViewController = nil;
}

- (void)setUp {
    [super setUp];
    self.richPushNotificationViewController = (SocializeRichPushNotificationViewController*)self.viewController;
}
             
- (void)testViewDidLoad {
    [[self.mockNavigationItem expect] setRightBarButtonItem:self.mockDoneButton];
    [self.richPushNotificationViewController viewDidLoad];
}

@end
