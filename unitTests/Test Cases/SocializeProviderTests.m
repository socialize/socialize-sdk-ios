/*
 * SocializeProviderTests.m
 * SocializeSDK
 *
 * Created on 6/14/11.
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

#import "SocializeProviderTests.h"
#import "SocializeProvider.h"

@implementation SocializeProviderTests

- (id)requestLoading:(NSMutableURLRequest *)request
{
    // This allows us to disable real network call.
    return nil;
}


- (void)testThirdPartyAuthentication 
{
    SocializeProvider* provider = [[[SocializeProvider alloc] init] autorelease];
    
    NSString* accessToken = @"accessTokenForSocialize";
    NSDate* expirationDate = [NSDate date];
    
    [provider authenticateWithThirdPartyAccessToken:accessToken andExpirationDate:expirationDate delegate:nil];
    
    GHAssertEqualStrings(accessToken, provider.accessToken, nil);
    GHAssertEqualObjects(expirationDate, provider.expirationDate, nil);
}

-(void) testRequestWithParams
{
    SocializeProvider* provider = [[[SocializeProvider alloc] init] autorelease];
    
    NSString* accessToken = @"accessTokenForSocialize";
    NSDate* expirationDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    [provider authenticateWithThirdPartyAccessToken:accessToken andExpirationDate:expirationDate delegate:nil];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   @"comment", @"method",
                                   nil];
    
    [provider requestWithParams:params andDelegate:self];
    
    NSString* expectedRequestUrl = @"http://dev.getsocialize.com/socialize/v1/comment?parameter_key_2=parameter_value_2&sdk=ios&sdk_version=1&access_token=accessTokenForSocialize&format=json&parameter_key_1=parameter_value_1";
    
    
    GHAssertEqualStrings(expectedRequestUrl, provider.request.url, nil);
}

-(void) testRequestWithoutAPIMethod
{
    SocializeProvider* provider = [[[SocializeProvider alloc] init] autorelease];
    
    NSString* accessToken = @"accessTokenForSocialize";
    NSDate* expirationDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    [provider authenticateWithThirdPartyAccessToken:accessToken andExpirationDate:expirationDate delegate:nil];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];
    
    [provider requestWithParams:params andDelegate:self];
    
    GHAssertEqualStrings(nil, provider.request.url, nil);
}

-(void) testRequestWithParamsAndGetMethod
{
    SocializeProvider* provider = [[[SocializeProvider alloc] init] autorelease];
    
    NSString* accessToken = @"accessTokenForSocialize";
    NSDate* expirationDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    [provider authenticateWithThirdPartyAccessToken:accessToken andExpirationDate:expirationDate delegate:nil];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];
    
    [provider requestWithMethodName:@"comment" andParams:params andHttpMethod:@"GET" andDelegate:self];
    
    NSString* expectedRequestUrl = @"http://dev.getsocialize.com/socialize/v1/comment?parameter_key_2=parameter_value_2&sdk=ios&sdk_version=1&access_token=accessTokenForSocialize&format=json&parameter_key_1=parameter_value_1";
    
    GHAssertEqualStrings(expectedRequestUrl, provider.request.url, nil);
}

-(void) testRequestWithParamsAndPostMethod
{
    SocializeProvider* provider = [[[SocializeProvider alloc] init] autorelease];
    
    NSString* accessToken = @"accessTokenForSocialize";
    NSDate* expirationDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    [provider authenticateWithThirdPartyAccessToken:accessToken andExpirationDate:expirationDate delegate:nil];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   [NSData data], @"parametr_key_3",
                                   nil];
    
    [provider requestWithMethodName:@"comment" andParams:params andHttpMethod:@"POST" andDelegate:self];
    
    NSString* expectedRequestUrl = @"http://dev.getsocialize.com/socialize/v1/comment?sdk_version=1&parameter_key_1=parameter_value_1&format=json&parameter_key_2=parameter_value_2&sdk=ios&access_token=accessTokenForSocialize";
    
    
    GHAssertEqualStrings(expectedRequestUrl, provider.request.url, nil);
}

@end
