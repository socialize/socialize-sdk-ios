//
//  OCMockObject+SocializeHelpers.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "OCMockRecorder+SocializeHelpers.h"

@implementation OCMockRecorder (SocializeHelpers)

- (id)andReturnFromBlock:(id (^)())block {
    return [self andDo:^(NSInvocation *inv) {
        id retVal = block();
        [inv setReturnValue:&retVal];
    }];
}

@end
