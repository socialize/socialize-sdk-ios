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
#import <GHUnitIOS/GHMockNSURLConnection.h>
#import "OAAsynchronousDataFetcher.h"
#import <OCMock/OCMock.h>

@implementation SocializeRequestTests
/*
- (void)testSuccessGetRequest {
    [self prepare];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];
    
    _request = [SocializeRequest getRequestWithParams:params httpMethod:@"GET" delegate:self requestURL:@"www.google.com"];
    
    _connection = [[GHMockNSURLConnection alloc] initWithRequest:nil delegate:_request startImmediately:NO];	
    [_connection receiveHTTPResponseWithStatusCode:204 headers:nil afterDelay:0.1];
    [_connection receiveData:[NSData data] afterDelay:0.2];
    [_connection finishAfterDelay:0.4];
    
    [_request connect];
    
    GHAssertTrue([_request loading], nil);
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:3.0];
}
*/


-(void)testRequestCreation{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];

    _request = [SocializeRequest getRequestWithParams:params httpMethod:@"GET" delegate:self requestURL:@"www.google.com"];
    GHAssertEqualStrings(@"GET", _request.httpMethod, @"should be equal");
    GHAssertEqualStrings(@"www.google.com?parameter_key_2=parameter_value_2&parameter_key_1=parameter_value_1", _request.url, @"should be equal");
}

/*
- (void)testSuccessPostRequest {
    [self prepare];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"hello_there", @"udid",
                                   nil];
    
    _request = [SocializeRequest getRequestWithParams:params httpMethod:@"POST" delegate:self requestURL:@"http://www.dev.getsocialize.com/v1/authenticate/"];
    [_request retain];
    [_request connect];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:30.0];
}

- (void)testFaildGetRequest {
    [self prepare];
    _request = [SocializeRequest getRequestWithParams:nil httpMethod:@"GET" delegate:self requestURL:@"invalidparam"];
    [_request retain];
    
    [_request connect];  
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:30.0];
}
*/

/*-(void)testOAInterfaceForRequests1{

    id mockProvider = [OCMockObject mockForClass:[OAAsynchronousDataFetcher class]];
    [[mockProvider expect] start];
    [self prepare];
    _request = [SocializeRequest getRequestWithParams:nil httpMethod:@"GET" delegate:self requestURL:@"invalidparam"];
    [_request connect];
    [mockProvider verify];
}
*/


-(void)testOAInterfaceForRequests2{
    
    id mockRequest = [OCMockObject mockForClass:[OAMutableURLRequest class]];
    [[mockRequest expect] setHTTPMethod:@"GET"];
    [[mockRequest expect] prepare];
    _request = [SocializeRequest getRequestWithParams:nil httpMethod:@"GET" delegate:self requestURL:@"invalidparam"];
    _request.request = mockRequest;
    [_request connect];
    [mockRequest verify];

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
    // GHAssertEqualObjects(_expectedError, error, nil);
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
