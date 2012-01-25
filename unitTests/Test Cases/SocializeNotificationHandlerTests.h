//
//  SocializeNotificationHandlerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeNotificationHandler.h"

@interface SocializeNotificationHandlerTests : GHAsyncTestCase

@property (nonatomic, retain) SocializeNotificationHandler *notificationHandler;
@property (nonatomic, retain) SocializeNotificationHandler *origNotificationHandler;
@property (nonatomic, retain) id mockDisplayWindow;
@end
