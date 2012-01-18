//
//  SocializeProfileViewControllerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/5/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeProfileViewController.h"
#import "SocializeBaseViewControllerTests.h"

@interface SocializeProfileViewControllerTests : SocializeBaseViewControllerTests
@property (nonatomic, retain) SocializeProfileViewController *profileViewController;
@property (nonatomic, retain) id mockImagesCache;
@property (nonatomic, retain) id mockProfileImageView;
@property (nonatomic, retain) id mockDefaultProfileImage;
@property (nonatomic, retain) id mockProfileImageActivityIndicator;
@property (nonatomic, retain) id mockUserNameLabel;
@property (nonatomic, retain) id mockUserDescriptionLabel;
@property (nonatomic, retain) id mockActivityViewController;
@end
