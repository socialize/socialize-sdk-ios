//
//  SocializeShareCreatorTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeUIShareCreator.h"
#import "SocializeActionTests.h"

@interface SocializeUIShareCreatorTests : SocializeActionTests
@property (nonatomic, retain) SocializeUIShareCreator *shareCreator;
@property (nonatomic, retain) id mockMessageComposerClass;
@property (nonatomic, retain) id mockMailComposerClass;
@property (nonatomic, retain) id mockApplication;
@property (nonatomic, assign) BOOL disableMail;
@property (nonatomic, assign) BOOL disableSMS;
@end
