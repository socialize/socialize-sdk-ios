//
//  SocializeBubbleTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/12/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "SocializeBubbleView.h"

@interface SocializeBubbleViewTests : GHAsyncTestCase
@property (nonatomic, retain) SocializeBubbleView *socializeBubbleView;
@property (nonatomic, retain) SocializeBubbleView *origSocializeBubbleView;
@property (nonatomic, assign) CGSize testSize;
@property (nonatomic, retain) id mockContentView;
@end
