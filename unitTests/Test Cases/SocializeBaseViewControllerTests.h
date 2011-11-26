//
//  SocializeBaseViewControllerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "ImagesCache.h"

@class SocializeBaseViewController;

@interface SocializeBaseViewControllerTests : GHTestCase
+ (SocializeBaseViewController*)createController;
@property (nonatomic, retain) SocializeBaseViewController *viewController;
@property (nonatomic, retain) SocializeBaseViewController *origViewController;
@property (nonatomic, retain) id mockNavigationController;
@property (nonatomic, retain) id mockNavigationItem;
@property (nonatomic, retain) id mockNavigationBar;
@property (nonatomic, retain) id mockSocialize;
@property (nonatomic, retain) id mockGenericAlertView;
@property (nonatomic, retain) id mockDoneButton;
@property (nonatomic, retain) id mockEditButton;
@property (nonatomic, retain) id mockSendButton;
@property (nonatomic, retain) id mockSaveButton;
@property (nonatomic, retain) id mockCancelButton;
@property (nonatomic, retain) id mockBundle;
@property (nonatomic, retain) id mockImagesCache;
- (void)expectServiceFailureWithError:(NSError*)error;
- (void)expectAndSimulateLoadOfImage:(UIImage*)image fromURL:(NSString*)url;
@end
