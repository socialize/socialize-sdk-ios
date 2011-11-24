//
//  TestUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestUtils.h"

@implementation OCMockRecorder (TestUtils)
- (id)andReturnBool:(BOOL)b {
    return [self andReturnValue:OCMOCK_VALUE(b)];
}

- (id)andReturnUInteger:(NSUInteger)i {
    return [self andReturnValue:OCMOCK_VALUE(i)];
}

- (id)andReturnInteger:(NSInteger)i {
    return [self andReturnValue:OCMOCK_VALUE(i)];
}

@end

void RunOnMainThread(void (^blk)()) {
    if ([NSThread isMainThread]) {
        NSLog(@"Running block directly");
        blk();
    } else {
        NSLog(@"Adding block to queue");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"Running block on queue");
            blk();
        });
    }
}

