//
//  SocializeProfileViewControllerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/5/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeProfileViewController.h"

@interface SocializeProfileViewControllerTests : GHAsyncTestCase
@property (nonatomic, retain) SocializeProfileViewController *profileViewController;
@property (nonatomic, retain) SocializeProfileViewController *origProfileViewController;
@property (nonatomic, retain) id mockDelegate;
@property (nonatomic, retain) id mockProfileEditViewController;
@property (nonatomic, retain) id mockNavigationController;
@property (nonatomic, retain) id mockNavigationItem;
@property (nonatomic, retain) id mockNavigationBar;
@property (nonatomic, retain) id mockSocialize;
@property (nonatomic, retain) id mockImagesCache;
@property (nonatomic, retain) id mockProfileImageView;
@property (nonatomic, retain) id mockDefaultProfileImage;
@property (nonatomic, retain) id mockProfileImageActivityIndicator;
@property (nonatomic, retain) id mockUserNameLabel;
@property (nonatomic, retain) id mockUserDescriptionLabel;
@property (nonatomic, retain) id mockDoneButton;
@property (nonatomic, retain) id mockEditButton;
@property (nonatomic, retain) id mockActivityViewController;
@end
