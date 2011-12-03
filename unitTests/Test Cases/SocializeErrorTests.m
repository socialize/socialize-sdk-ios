//
//  SocializeErrorTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/3/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeErrorTests.h"
#import "SocializeErrorDefinitions.h"
#import "NSError+Socialize.h"
#import "SocializeError.h"

@implementation SocializeErrorTests

- (void)testDefaultErrorDescriptions {
    for (NSUInteger code = SocializeErrorUnknown+1; code < SocializeNumErrors; code++) {
        NSError *error = [NSError defaultSocializeErrorForCode:code];
        NSString *localizedDescription = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        GHAssertTrue([localizedDescription length] > 0, @"Bad description");
    }
}

- (void)testUnexpectedJsonErrorContainsResponse {
    NSString *testResponse = @"testResponse";
    NSError *error = [NSError socializeUnexpectedJSONResponseErrorWithResponse:testResponse description:@""];
    NSString *response = [error.userInfo objectForKey:kSocializeErrorResponseBodyKey];
    GHAssertNotNil(response, @"Missing Response");
}

- (void)testServerReturnedErrorsContainsErrors {
    id mockError = [OCMockObject mockForProtocol:@protocol(SocializeError)];
    [[[mockError stub] andReturn:@"testError"] error];
    NSArray *testErrors = [NSArray arrayWithObject:mockError];
    NSError *error = [NSError socializeServerReturnedErrorsErrorWithErrorsArray:testErrors];
    NSArray *errors = [error.userInfo objectForKey:kSocializeErrorServerErrorsArrayKey];
    GHAssertEquals(testErrors, errors, @"Missing Errors");
}

@end
