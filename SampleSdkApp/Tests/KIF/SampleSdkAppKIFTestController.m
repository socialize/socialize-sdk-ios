//
//  SampleKIFTestController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SampleSdkAppKIFTestController.h"
#import "KIFTestScenario+SampleSdkAppAdditions.h"
#import "StringHelper.h"

static NSString *UUIDString() {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

static NSString *SampleSdkAppKIFTestControllerRunID = nil;

@implementation SampleSdkAppKIFTestController


- (void)initializeScenarios;
{
//    [self addScenario:[KIFTestScenario scenarioToTestCommentsViewControllerWithAutoAuth]];
    [self addScenario:[KIFTestScenario scenarioToAuthenticate]];

//    [self addScenario:[KIFTestScenario scenarioToTestViewOtherProfile]];
//    [self addScenario:[KIFTestScenario scenarioToTestUserProfile]];
    [self addScenario:[KIFTestScenario scenarioToTestActionBar]];

    //    [self addScenario:[KIFTestScenario scenarioToTestFacebook]];

}

+ (NSString*)runID {
    if (SampleSdkAppKIFTestControllerRunID == nil) {
        NSString *uuid = UUIDString();
        NSString *sha1 = [uuid sha1];
        NSString *runID = [sha1 substringToIndex:8];
        
        SampleSdkAppKIFTestControllerRunID = runID;
    }
    
    return SampleSdkAppKIFTestControllerRunID;
}

+ (NSString*)testURL:(NSString*)suffix {
    return [NSString stringWithFormat:@"http://itest.%@/%@", [self runID], suffix];
}

@end
