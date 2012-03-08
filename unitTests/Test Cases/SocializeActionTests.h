//
//  SocializeActionTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeTestCase.h"
#import "SocializeAction.h"

@interface SocializeActionTests : SocializeTestCase
@property (nonatomic, retain) SocializeAction *action;
@property (nonatomic, retain) id partialAction;
@property (nonatomic, retain) id mockDisplay;
@property (nonatomic, retain) id mockSocialize;

- (id)createAction;
- (void)executeActionAndWaitForStatus:(int)status fromTest:(SEL)test;
- (void)executeAction:(SocializeAction*)action andWaitForStatus:(int)status;

- (void)succeedPostingToFacebookWall;
- (void)succeedFacebookAuthentication;
- (void)failFacebookAuthentication;
- (void)failTwitterAuthentication;
- (void)succeedTwitterAuthentication;

@end
