//
//  SampleKIFTestController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/14/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "KIFTestController.h"

@interface SampleSdkAppKIFTestController : KIFTestController

+ (NSString*)testURL:(NSString*)suffix;
+ (NSString*)runID;
+ (void)enableValidFacebookSession;
+ (void)disableValidFacebookSession;

@end
