/*
 * SocializeEntityFormatterTests.m
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

#import <OCMock/OCMock.h>
#import "JSONKit.h"
#import "Socialize.h"
#import "SocializeEntityJSONFormatter.h"
#import "SocializeEntityFormatterTests.h"


@interface SocializeEntityFormatterTests()
@end



@implementation SocializeEntityFormatterTests

-(void)testToEntity
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/entity_single_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    
    //[[mockEntity expect]setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    [[mockEntity expect]setKey:[JSONDictionaryToParse objectForKey:@"key"]];
    [[mockEntity expect]setName:[JSONDictionaryToParse objectForKey:@"name"]];
    [[mockEntity expect]setViews:[[JSONDictionaryToParse objectForKey:@"views"]intValue]];
    [[mockEntity expect]setLikes:[[JSONDictionaryToParse objectForKey:@"likes"]intValue]];
    [[mockEntity expect]setComments:[[JSONDictionaryToParse objectForKey:@"comments"]intValue]];
    [[mockEntity expect]setShares:[[JSONDictionaryToParse objectForKey:@"shares"]intValue]];
    [[mockEntity expect]setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    [[mockEntity expect]setMeta:[JSONDictionaryToParse objectForKey:@"meta"]];
    
    
    SocializeEntityJSONFormatter * entityFormatter = [[[SocializeEntityJSONFormatter alloc]initWithFactory:_factory] autorelease];
    
    [entityFormatter toObject:mockEntity fromString:JSONStringToParse];
    [mockEntity verify];    
}

-(void)testFromEntity
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"requests/entity_create.json"];
    NSArray * JSONArrayParse =(NSArray *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    NSString * expectedKeyFieldValue =(NSString *)[[JSONArrayParse objectAtIndex:0]objectForKey:@"key"];
    NSString * expectedNameFieldValue =(NSString *)[[JSONArrayParse objectAtIndex:0]objectForKey:@"name"];
    NSString * expectedMeta = @"expectedMeta";
    
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    [[[mockEntity expect] andReturn:expectedKeyFieldValue] key];
    [[[mockEntity expect] andReturn:expectedNameFieldValue] name];
    [[[mockEntity stub] andReturn:expectedMeta] meta];
    
    SocializeEntityJSONFormatter * entityFormatter = [[[SocializeEntityJSONFormatter alloc]initWithFactory:_factory] autorelease];
    
    NSMutableDictionary * objectDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    [entityFormatter toDictionary:objectDictionary fromObject:mockEntity];
    
    [mockEntity verify];
    
    //Verify Dictionary values.
    NSString * actualKeyFieldValue = (NSString *) [objectDictionary valueForKey:@"key"];
    NSString * actualNameFieldValue = (NSString *) [objectDictionary valueForKey:@"name"];
    NSString * actualMeta = (NSString *) [objectDictionary valueForKey:@"meta"];
    GHAssertEqualStrings(expectedKeyFieldValue, actualKeyFieldValue, @"Entity formatter (toDictionary) - expected keyValue=%@ != actual keyValue=%@", expectedKeyFieldValue, actualKeyFieldValue);
    
    GHAssertEqualStrings(expectedNameFieldValue, actualNameFieldValue, @"Entity formatter (toDictionary) - expected nameValue=%@ != actual nameValue=%@", expectedKeyFieldValue, actualNameFieldValue);
    GHAssertEqualStrings(expectedMeta, actualMeta, @"bad meta");
    
}


#pragma mark helper methods


@end
