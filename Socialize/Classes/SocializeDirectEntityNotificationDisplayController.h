//
//  SocializeDirectEntityNotificationDisplayController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeNotificationDisplayController.h"
#import "SocializeBaseViewControllerDelegate.h"
#import "SocializeServiceDelegate.h"
#import "SocializeObjects.h"

@class Socialize;
@class SocializeDummyViewController;

@interface SocializeDirectEntityNotificationDisplayController : SocializeNotificationDisplayController <SocializeBaseViewControllerDelegate, SocializeServiceDelegate, UINavigationControllerDelegate>
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) SocializeDummyViewController *dummyController;
@property (nonatomic, retain) id<SocializeEntity> entity;
@property (nonatomic, retain) Socialize *socialize;

@end
