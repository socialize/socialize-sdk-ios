//
//  KIFTestScenario+SampleAdditions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestScenario.h"

@interface KIFTestScenario (SampleSdkAppAdditions)

+ (id)scenarioToAuthenticate;
+ (id)scenarioToCreateEntity;
+ (id)scenarioToGetEntity;
+ (id)scenarioToTestUserProfile;
+ (id)scenarioToLikeAndUnlikeEntity;
+ (id)scenarioToViewEntity;
+ (id)scenarioToTestCommentsViewControllerWithAutoAuth;
+ (id)scenarioToTestActionBar;
@end
