/*
 * SocializeRequestTests.m
 * SocializeSDK
 *
 * Created on 6/10/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * See Also: http://gabriel.github.com/gh-unit/
 */

#import "SocializeRequestTests.h"
//#import <GHUnitIOS/GHMockNSURLConnection.h>
#import "OAAsynchronousDataFetcher.h"
#import "OAServiceTicket.h"
#import <OCMock/OCMock.h>
#import "StringHelper.h"

@implementation SocializeRequestTests
@synthesize expectedError = _expectedError;

- (BOOL)shouldRunOnMainThread {
    return YES;
}

-(BOOL) compareParams: (NSArray*)actual and: (NSArray*)expected
{
    if([actual count] != [expected count])
        return NO;
    
    for(int i = 0; i< [actual count]; i++)
    {
        if([[actual objectAtIndex:i] name] == [[expected objectAtIndex:i] name] && [(SocializeOARequestParameter*)[actual objectAtIndex:i] value] == [(SocializeOARequestParameter*)[expected objectAtIndex:i] value])
        {
            return NO;
        }
    }
    return YES;
}
//////////////////////////////////////////////////////////////////

-(void)testRequestCreation{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];

    _request = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:@"entity/" expectedJSONFormat:SocializeDictionaryWithListAndErrors params:params];
    GHAssertEqualStrings(@"GET", _request.httpMethod, @"should be equal");
    GHAssertEqualStrings(@"entity/", _request.resourcePath, @"should be equal");
}



-(void)testRequestForMultipleIds
{
    NSArray *ids = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], nil];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:ids,@"id", nil];   
          
    _request = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:@"entity/" expectedJSONFormat:SocializeDictionaryWithListAndErrors params:params];

    _request.dataFetcher = [OCMockObject niceMockForClass: [OAAsynchronousDataFetcher class]];
    
    [(OAAsynchronousDataFetcher*)[[_request.dataFetcher expect] andDo:^(NSInvocation *inv) {
        [self notify:kGHUnitWaitStatusSuccess];
    }] start];

    [self prepare];
    [_request connect];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];

    NSArray* oaRequestParamsActual = [_request.request socializeParameters];
    
    OARequestParameter* p1 = [OARequestParameter requestParameterWithName:@"id" value:@"1"];
    OARequestParameter* p2 = [OARequestParameter requestParameterWithName:@"id" value:@"2"];
    OARequestParameter* p3 = [OARequestParameter requestParameterWithName:@"id" value:@"3"];
    NSArray* oaRequestParamsExpected = [NSArray arrayWithObjects:p1, p2, p3, nil];
    
    GHAssertTrue([self compareParams: oaRequestParamsActual and: oaRequestParamsExpected], nil);
}

-(void)testRequestForMultipleIdsAndKeys
{
    NSArray *ids = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"url_1",@"url_2", nil];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:ids,@"id", keys, @"key", nil];   
    
    _request = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:@"entity/" expectedJSONFormat:SocializeDictionaryWithListAndErrors params:params];
    _request.dataFetcher = [OCMockObject niceMockForClass: [OAAsynchronousDataFetcher class]];

    [(OAAsynchronousDataFetcher*)[[_request.dataFetcher expect] andDo:^(NSInvocation *inv) {
        [self notify:kGHUnitWaitStatusSuccess];
    }] start];

    [self prepare];
    [_request connect];
    NSLog(@"#####################");
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];

    NSArray* oaRequestParamsActual = [_request.request socializeParameters];
    
    OARequestParameter* p1 = [OARequestParameter requestParameterWithName:@"id" value:@"1"];
    OARequestParameter* p2 = [OARequestParameter requestParameterWithName:@"id" value:@"2"];
    OARequestParameter* p3 = [OARequestParameter requestParameterWithName:@"id" value:@"3"];
    OARequestParameter* p4 = [OARequestParameter requestParameterWithName:@"key" value:@"url_1"];
    OARequestParameter* p5 = [OARequestParameter requestParameterWithName:@"key" value:@"url_2"];
    NSArray* oaRequestParamsExpected = [NSArray arrayWithObjects:p1, p2, p3, p4, p5, nil];
    
    GHAssertTrue([self compareParams: oaRequestParamsActual and: oaRequestParamsExpected], nil);
}

-(void)testOAInterfaceForRequests2
{    
    NSString   *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    NSString   *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSString * userAgentStr = [NSString stringWithFormat:@"iOS-%@/%@ SocializeSDK/v%@; %@_%@; BundleID/%@;",
                               [[UIDevice currentDevice]systemVersion],
                               [[UIDevice currentDevice]model],
                               SOCIALIZE_VERSION_STRING,
                               language,
                               countryCode,
                               [[NSBundle mainBundle] bundleIdentifier]];
    NSURL *expectedURL = [NSURL URLWithString:@"http://api.getsocialize.com/v1/entity/"];
    
    id mockRequest = [OCMockObject mockForClass:[OAMutableURLRequest class]];
    [[mockRequest expect] setURL:expectedURL];
    [[mockRequest expect] setHTTPMethod:@"GET"];
    [[mockRequest expect] addValue:userAgentStr forHTTPHeaderField:@"User-Agent"];
    [[mockRequest expect] setSocializeParameters:[NSMutableArray arrayWithCapacity:0]];
    [[mockRequest expect] prepare];
    _request = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:@"entity/" expectedJSONFormat:SocializeDictionaryWithListAndErrors params:nil];
    _request.request = mockRequest;
    [_request configureURLRequest];
    [mockRequest verify];
}

-(void)testConfigureURLRequestIsCalled {
    _request = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:@"entity/" expectedJSONFormat:SocializeDictionaryWithListAndErrors params:nil];
    id mockRequest = [OCMockObject partialMockForObject:_request];
    [[[mockRequest expect] andDo:^(NSInvocation *inv) {
        [self notify:kGHUnitWaitStatusSuccess];
    }] configureURLRequest];
    
    [self prepare];
    [_request connect];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
    
    [mockRequest verify];
}


-(void)testTokenRequestResponceFailed
{
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeRequestDelegate)];

//    _request = [SocializeRequest getRequestWithParams:nil  expectedJSONFormat:SocializeDictionaryWIthListAndErrors httpMethod:@"GET" delegate:mockDelegate requestURL:@"invalidparam"];
    _request = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:@"entity/" expectedJSONFormat:SocializeDictionaryWithListAndErrors params:nil];
    _request.delegate = mockDelegate;
    
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    int code = 404;
    [[[mockResponse stub]andReturnValue:OCMOCK_VALUE(code)]statusCode];
    
    self.expectedError = [NSError errorWithDomain:@"SocializeSDK" code:code userInfo:nil];
    [[mockDelegate expect]request:OCMOCK_ANY didFailWithError:OCMOCK_ANY];
    
    OAServiceTicket* tiket = [[OAServiceTicket alloc] initWithRequest: nil response: mockResponse didSucceed: YES];
    [tiket retain];
    [_request tokenRequestTicket:tiket didFinishWithData:nil];
    [mockDelegate verify];
    [mockResponse verify];
}

-(void)testTokenRequestResponceSuccess
{
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeRequestDelegate)];
    
//    _request = [SocializeRequest getRequestWithParams:nil  expectedJSONFormat:SocializeDictionaryWIthListAndErrors httpMethod:@"GET" delegate:mockDelegate requestURL:@"invalidparam"];
    _request = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:@"entity/" expectedJSONFormat:SocializeDictionaryWithListAndErrors params:nil];
    _request.delegate = mockDelegate;

    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    int code = 200;
    [[[mockResponse stub]andReturnValue:OCMOCK_VALUE(code)]statusCode];
    
    self.expectedError = [NSError errorWithDomain:@"SocializeSDK" code:code userInfo:nil];
    NSData* data = [NSData data];
    [[mockDelegate expect]request:OCMOCK_ANY didLoadRawResponse:data];
    
    OAServiceTicket* tiket = [[OAServiceTicket alloc] initWithRequest: nil response: mockResponse didSucceed: YES];
    [_request tokenRequestTicket:tiket didFinishWithData:data];
    [mockDelegate verify];
    [mockResponse verify];
}

- (void)testThatTokenRequestDoesNotIncludeToken {
    SocializeRequest *request = [SocializeRequest secureRequestWithHttpMethod:@"POST"
                                                                 resourcePath:@"something/"
                                                           expectedJSONFormat:SocializeDictionary
                                                                       params:nil];

    request.tokenRequest = YES;
    [request configureURLRequest];
    NSString *authorization = [request.request valueForHTTPHeaderField:@"Authorization"];
    BOOL foundToken = [authorization containsString:@"oauth_token"];
    GHAssertFalse(foundToken, @"should not have token");
}

-(void)testCompereRequestWithNilParams
{
    SocializeRequest* first = [SocializeRequest requestWithHttpMethod:@"" resourcePath:@"" expectedJSONFormat:SocializeDictionary params:nil];
    SocializeRequest* second = [SocializeRequest requestWithHttpMethod:@"" resourcePath:@"" expectedJSONFormat:SocializeDictionary params:nil];
    GHAssertEqualObjects(first, second, nil);
}

- (id)requestLoading:(NSMutableURLRequest *)request
{
    return nil;
}

- (void)request:(SocializeRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
    [self notify:kGHUnitWaitStatusFailure];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSLog(@"responseBody %@", responseBody);
    [self notify:kGHUnitWaitStatusSuccess];
}

@end
