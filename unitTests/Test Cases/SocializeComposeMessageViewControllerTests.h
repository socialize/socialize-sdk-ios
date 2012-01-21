//
//  SocializeComposeMessageViewControllerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/15/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeComposeMessageViewController.h"
#import "SocializeBaseViewControllerTests.h"

@interface SocializeComposeMessageViewControllerTests : SocializeBaseViewControllerTests
@property (nonatomic, retain) SocializeComposeMessageViewController *composeMessageViewController;
@property (nonatomic, retain) id mockLocationManager;
@property (nonatomic, retain) id mockUpperContainer;
@property (nonatomic, retain) id mockLowerContainer;
@property (nonatomic, retain) id mockMapContainer;
@property (nonatomic, retain) id mockCommentTextView;
@property (nonatomic, retain) id mockLocationText;
@property (nonatomic, retain) id mockDoNotShareLocationButton;
@property (nonatomic, retain) id mockActivateLocationButton;
@property (nonatomic, retain) id mockMapOfUserLocation;
@property (nonatomic, retain) id mockDelegate;
@property (nonatomic, retain) id mockSendButton;
@property (nonatomic, retain) id mockMessageActionButtonContainer;

- (void)prepareForViewDidLoad;
@end
