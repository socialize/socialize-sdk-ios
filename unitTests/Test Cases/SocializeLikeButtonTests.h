//
//  SocializeLikeButtonTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/18/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTestCase.h"
#import "SocializeLikeButton.h"

@interface SocializeLikeButtonTests : SocializeTestCase
@property (nonatomic, retain) SocializeLikeButton *likeButton;

@property (nonatomic, retain) id mockEntity;
@property (nonatomic, retain) id mockActualButton;
@property (nonatomic, retain) id mockSocialize;
@property (nonatomic, retain) id mockDisplay;

@property (nonatomic, retain) id mockAuthenticatedUser;
@property (nonatomic, retain) UIButton *realButton;

@end
