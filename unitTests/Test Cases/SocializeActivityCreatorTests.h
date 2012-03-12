//
//  SocializeActivityCreatorTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeActionTests.h"
#import "SocializeActivityCreator.h"

@interface SocializeActivityCreatorTests : SocializeActionTests
@property (nonatomic, retain) id mockActivity;
@property (nonatomic, retain) SocializeActivityCreator *activityCreator;
@property (nonatomic, retain) id mockOptions;
@property (nonatomic, retain) NSError *lastError;
- (void)succeedSocializeCreate;
- (void)expectSetTwitterInActivity:(id)mockActivity;
- (void)selectJustFacebookInOptions;
- (void)selectJustTwitterInOptions;
- (void)succeedFacebookWallPost;

@end
