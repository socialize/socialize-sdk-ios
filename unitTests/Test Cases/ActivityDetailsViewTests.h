//
//  ActivityDetailsViewTests.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 1/2/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeActivityDetailsView.h"

@interface ActivityDetailsViewTests : GHTestCase

@property (nonatomic, retain) SocializeActivityDetailsView*     activityDetailsView;
@property (nonatomic, retain) id                                partialActivityDetailsView;
@property (nonatomic, retain) id                                mockHtmlCreator;
@property (nonatomic, retain) id                                mockActivityMessageView;
@end
