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

@implementation SocializeRequestTests

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

- (void)testSuccessPostRequest {
    [self prepare];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   [[[UIImage alloc] init] autorelease], @"parameter_key_3",
                                   [[[NSData alloc] init] autorelease], @"parameter_key_4",
                                   nil];
    
    _request = [SocializeRequest getRequestWithParams:params httpMethod:@"POST" delegate:self requestURL:@"www.google.com"];
    
    _connection = [[GHMockNSURLConnection alloc] initWithRequest:nil delegate:_request startImmediately:NO];	
    [_connection receiveHTTPResponseWithStatusCode:204 headers:nil afterDelay:0.1];
    [_connection receiveData:[NSData data] afterDelay:0.2];
    [_connection finishAfterDelay:0.4];
    
    [_request connect];
    
    GHAssertTrue([_request loading], nil);
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:3.0];
}

- (void)testFaildGetRequest {
    [self prepare];
    _request = [SocializeRequest getRequestWithParams:nil httpMethod:@"GET" delegate:self requestURL:@"www.google.com"];
    
    _connection = [[GHMockNSURLConnection alloc] initWithRequest:nil delegate:_request startImmediately:NO];	
    [_connection receiveHTTPResponseWithStatusCode:204 headers:nil afterDelay:0.1];
    _expectedError = [NSError errorWithDomain:@"Socialize" code:404 userInfo:nil];
    [_connection failWithError:_expectedError afterDelay:0.2];
    
    [_request connect];  
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:2.0];
}

- (id)requestLoading:(NSMutableURLRequest *)request
{
    return _connection;
}

- (void)request:(SocializeRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    GHAssertEquals([(NSHTTPURLResponse *)response statusCode], 204, nil);
}

- (void)request:(SocializeRequest *)request didFailWithError:(NSError *)error
{
    GHAssertEqualObjects(_expectedError, error, nil);
    [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testFaildGetRequest)];
}

- (void)request:(SocializeRequest *)request didLoadRawResponse:(NSData *)data
{
    GHAssertEqualObjects(data, [NSData data], nil);
    [self notify:kGHUnitWaitStatusSuccess];
}


@end
