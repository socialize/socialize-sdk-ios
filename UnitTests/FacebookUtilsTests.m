//
//  FacebookUtilsTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/22/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "FacebookUtilsTests.h"
#import "SocializeFacebookInterface.h"
#import "SZFacebookUtils.h"

@implementation FacebookUtilsTests
@synthesize mockSharedFacebookInterface = _mockSharedFacebookInterface;

- (void)setUp {
    [SocializeFacebookInterface startMockingClass];
    self.mockSharedFacebookInterface = [OCMockObject mockForClass:[SocializeFacebookInterface class]];
    [[[SocializeFacebookInterface stub] andReturn:self.mockSharedFacebookInterface] sharedFacebookInterface];
}

- (void)tearDown {
    self.mockSharedFacebookInterface = nil;
    [SocializeFacebookInterface stopMockingClassAndVerify];
}

- (void)succeedFacebookPost {
    [[[self.mockSharedFacebookInterface expect] andDo4:^(id _1, id _2, id _3, id completion) {
        void (^completionBlock)(id result, NSError *error) = completion;
        completionBlock(nil, nil);
    }] requestWithGraphPath:OCMOCK_ANY params:OCMOCK_ANY httpMethod:OCMOCK_ANY completion:OCMOCK_ANY];
 }

@end
