//
//  KIFTestScenario+SampleAdditions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestScenario.h"

@interface KIFTestScenario (SampleSdkAppAdditions)

+ (id)scenarioToTestUserProfile;
//+ (id)scenarioToTestActionBar;
//+ (id)scenarioToTestViewOtherProfile;
//+ (id)scenarioToTestLikeButton;
//+ (id)scenarioToTestDirectURLNotification;
+ (id)scenarioToSleep;
+ (id)scenarioToTestFacebookAuth;
+ (id)scenarioToTestTwitterAuth;
+ (id)scenarioToTestCommentsList;
+ (id)scenarioToTestComposeCommentNoAuth;
+ (id)scenarioToTestComposeCommentTwitterAuth;
+ (id)scenarioToTestComposeCommentFacebookAuth;
+ (id)scenarioToTestLikeNoAuth;
+ (id)scenarioToTestLikeTwitterAuth;

@end
