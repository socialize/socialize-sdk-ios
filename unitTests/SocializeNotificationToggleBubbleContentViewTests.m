//
//  SocializeNotificationToggleBubbleContentViewTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationToggleBubbleContentViewTests.h"
#import "SocializeNotificationToggleBubbleContentView.h"

@implementation SocializeNotificationToggleBubbleContentViewTests
@synthesize notificationToggleBubbleContentView = notificationToggleBubbleContentView_;
@synthesize mockEnabledStateLabel = mockEnabledStateLabel_;
@synthesize mockDescriptionLabel = mockDescriptionLabel_;

- (void)setUp {
    self.notificationToggleBubbleContentView = [[[SocializeNotificationToggleBubbleContentView alloc] init] autorelease];
    
    self.mockEnabledStateLabel = [OCMockObject mockForClass:[UILabel class]];
    self.notificationToggleBubbleContentView.enabledStateLabel = self.mockEnabledStateLabel;
    
    self.mockDescriptionLabel = [OCMockObject mockForClass:[UILabel class]];
    self.notificationToggleBubbleContentView.descriptionLabel = self.mockDescriptionLabel;
}

- (void)tearDown {
    [self.mockEnabledStateLabel verify];
    [self.mockDescriptionLabel verify];
    self.mockEnabledStateLabel = nil;
    self.mockDescriptionLabel = nil;
    
    self.notificationToggleBubbleContentView = nil;
}

- (void)testConfiguringForNotificationsEnabled {
    [[self.mockEnabledStateLabel expect] setText:OCMOCK_ANY];
    [[self.mockEnabledStateLabel expect] setTextColor:[UIColor greenColor]];
    [[self.mockDescriptionLabel expect] setText:OCMOCK_ANY];
    
    [self.notificationToggleBubbleContentView configureForNotificationsEnabled:YES];
}

- (void)testConfiguringForNotificationsDisabled {
    [[self.mockEnabledStateLabel expect] setText:OCMOCK_ANY];
    [[self.mockEnabledStateLabel expect] setTextColor:[UIColor redColor]];
    [[self.mockDescriptionLabel expect] setText:OCMOCK_ANY];

    [self.notificationToggleBubbleContentView configureForNotificationsEnabled:NO];
}

- (void)testLoadingFromNib {
    SocializeNotificationToggleBubbleContentView *contentView = [SocializeNotificationToggleBubbleContentView notificationToggleBubbleContentViewFromNib];
    GHAssertNotNil(contentView, @"Didn't load");
}

@end
