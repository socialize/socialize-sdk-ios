//
//  SocializeNotificationToggleBubbleContentViewTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@class SocializeNotificationToggleBubbleContentView;

@interface SocializeNotificationToggleBubbleContentViewTests : GHAsyncTestCase
@property (nonatomic, retain) SocializeNotificationToggleBubbleContentView *notificationToggleBubbleContentView;
@property (nonatomic, retain) id mockEnabledStateLabel;
@property (nonatomic, retain) id mockDescriptionLabel;
@end
