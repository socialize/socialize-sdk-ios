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
    NSError *error = [NSError socializeUnexpectedJSONResponseErrorWithResponse:testResponse reason:@""];
    NSString *response = [error.userInfo objectForKey:kSocializeErrorResponseBodyKey];
    GHAssertNotNil(response, @"Missing Response");
}

- (void)testServerReturnedErrorsContainsErrors {
    id mockError = [OCMockObject mockForProtocol:@protocol(SocializeError)];
    [[[mockError stub] andReturn:@"testError"] error];
    NSArray *testErrors = [NSArray arrayWithObject:mockError];
    id mockObjects = [OCMockObject mockForClass:[NSArray class]];
    NSError *error = [NSError socializeServerReturnedErrorsErrorWithErrorsArray:testErrors objectsArray:mockObjects];
    NSArray *errors = [error.userInfo objectForKey:kSocializeErrorServerErrorsArrayKey];
    NSArray *objects = [error.userInfo objectForKey:kSocializeErrorServerObjectsArrayKey];
    GHAssertEquals(testErrors, errors, @"Missing Errors");
    GHAssertEquals(mockObjects, objects, @"Missing Objects");
}

- (void)testServerReturnedHTTPErrorContainsMessage {
    NSString *testServerErrorMessage = @"Harp has been eating paint chips";
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockResponse stub] andReturnInteger:401] statusCode];
    NSError *error = [NSError socializeServerReturnedHTTPErrorErrorWithResponse:mockResponse responseBody:testServerErrorMessage];
    NSString *description = [error localizedDescription];
    GHAssertTrue([description containsString:testServerErrorMessage], @"Missing message");
}

@end
