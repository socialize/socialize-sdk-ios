//
//  SZTestHelper.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZTestHelper.h"

static SZTestHelper *sharedTestHelper;

@implementation SZTestHelper

+ (id)sharedTestHelper {
    if (sharedTestHelper == nil) {
        sharedTestHelper = [[[SZTestHelper alloc] init] autorelease];
    }
    
    return sharedTestHelper;
}

@end
