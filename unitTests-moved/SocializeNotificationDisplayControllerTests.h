//
//  SocializeNotificationDisplayControllerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/27/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTestCase.h"
#import "SocializeNotificationDisplayController.h"

@interface SocializeNotificationDisplayControllerTests : SocializeTestCase
@property (nonatomic, retain) id mockDelegate;
@property (nonatomic, readonly) SocializeNotificationDisplayController *notificationDisplayController;
@end
