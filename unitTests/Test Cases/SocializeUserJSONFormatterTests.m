/*
 * SocializeUserJSONFormatterTests.m
 * SocializeSDK
 *
 * Created on 6/20/11.
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

#import <OCMock/OCMock.h>
#import "SocializeUserJSONFormatterTests.h"
#import "SocializeUser.h"
#import "SocializeUserJSONFormatter.h"
#import "JSONKit.h"

@implementation SocializeUserJSONFormatterTests

- (void)testToUser
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/user_small_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    
    [[mockUser expect] setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    [[mockUser expect] setFirstName:[JSONDictionaryToParse objectForKey:@"first_name"]];
    [[mockUser expect] setLastName:[JSONDictionaryToParse objectForKey:@"last_name"]];
    [[mockUser expect] setUserName:[JSONDictionaryToParse objectForKey:@"username"]];
    [[mockUser expect] setSmallImageUrl:[JSONDictionaryToParse objectForKey:@"small_image_uri"]];
    [[mockUser expect] setCity:[JSONDictionaryToParse objectForKey:@"city"]];
    [[mockUser expect] setState:[JSONDictionaryToParse objectForKey:@"state"]];
    [[mockUser expect] setMeta:[JSONDictionaryToParse objectForKey:@"meta"]];   
    [[mockUser expect] setThirdPartyAuth: [JSONDictionaryToParse objectForKey:@"third_party_auth"]];
    
      
    SocializeUserJSONFormatter * userFormatter = [[[SocializeUserJSONFormatter alloc]initWithFactory:_factory] autorelease];
    
    [userFormatter toObject:mockUser fromDictionary:JSONDictionaryToParse];
    [mockUser verify];  
}


@end
