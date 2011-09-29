/*
 * SocializeFullUserJSONFormatterTests.m
 * SocializeSDK
 *
 * Created on 9/29/11.
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

#import "SocializeFullUserJSONFormatterTests.h"
#import "SocializeFullUserJSONFormatter.h"
#import "SocializeFullUser.h"
#import "JSONKit.h"

#import <OCMock/OCMock.h>

@implementation SocializeFullUserJSONFormatterTests

- (void)testToUser
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/user_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeFullUser)];
    
    [[mockUser expect] setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    [[mockUser expect] setFirstName:[JSONDictionaryToParse objectForKey:@"first_name"]];
    [[mockUser expect] setLastName:[JSONDictionaryToParse objectForKey:@"last_name"]];
    [[mockUser expect] setUserName:[JSONDictionaryToParse objectForKey:@"username"]];
    [[mockUser expect] setDescription:[JSONDictionaryToParse objectForKey:@"description"]];
    [[mockUser expect] setLocation:[JSONDictionaryToParse objectForKey:@"location"]];
    [[mockUser expect] setSex:[JSONDictionaryToParse objectForKey:@"sex"]];
    
    [[mockUser expect] setMeta:[JSONDictionaryToParse objectForKey:@"meta"]];
    [[mockUser expect] setSmallImageUrl:[JSONDictionaryToParse objectForKey:@"small_image_uri"]];
    [[mockUser expect] setMedium_image_uri:[JSONDictionaryToParse objectForKey:@"medium_image_uri"]];
    [[mockUser expect] setLarge_image_uri:[JSONDictionaryToParse objectForKey:@"large_image_uri"]];
    
    NSDictionary* stats = [JSONDictionaryToParse objectForKey:@"stats"];
    [[mockUser expect] setViews:[[stats objectForKey:@"views"]intValue]];
    [[mockUser expect] setLikes:[[stats objectForKey:@"likes"]intValue]];
    [[mockUser expect] setComments:[[stats objectForKey:@"comments"]intValue]];
    [[mockUser expect] setShare:[[stats objectForKey:@"shares"]intValue]];
    
    [[mockUser expect] setThirdPartyAuth: [JSONDictionaryToParse objectForKey:@"third_party_auth"]];
    
    
    SocializeFullUserJSONFormatter * userFormatter = [[[SocializeFullUserJSONFormatter alloc]initWithFactory:_factory] autorelease];
    
    [userFormatter toObject:mockUser fromDictionary:JSONDictionaryToParse];
    [mockUser verify];  
}

@end
