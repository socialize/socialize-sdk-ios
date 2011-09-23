/*
 * SocializeCommentFormaterTests.m
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
#import "SocializeCommentFormaterTests.h"
#import "SocializeEntityJSONFormatter.h"
#import "JSONKit.h"
#import "SocializeComment.h"
#import "SocializeApplicationJSONFormatter.h"
#import "SocializeUserJSONFormatter.h"

@implementation SocializeCommentFormaterTests

-(void) setUpClass
{
    [super setUpClass];
    _commentFormater = [[SocializeCommentJSONFormatter alloc] init];
}

-(void) tearDownClass
{
    [_commentFormater release]; _commentFormater = nil;
    [super tearDownClass];
}

-(void)testComment
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/comment_single_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    id mockComment = [OCMockObject mockForProtocol:@protocol(SocializeComment)];
    
    [[mockComment expect] setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    [[mockComment expect] setText:[JSONDictionaryToParse objectForKey:@"text"]];
    [[mockComment expect] setLat:[JSONDictionaryToParse valueForKey:@"lat"]];
    [[mockComment expect] setLng:[JSONDictionaryToParse valueForKey:@"lng"]];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [[mockComment expect] setDate:[df dateFromString:[JSONDictionaryToParse valueForKey:@"date"]]];
    [df release]; df = nil;
    
    [[mockComment expect] setEntity:OCMOCK_ANY];  
    [[mockComment expect] setApplication:OCMOCK_ANY];
    [[mockComment expect] setUser:OCMOCK_ANY];
    
    SocializeCommentJSONFormatter * commentFormatter = [[[SocializeCommentJSONFormatter alloc]initWithFactory:_factory] autorelease];
    
    [commentFormatter toObject:mockComment fromDictionary:JSONDictionaryToParse];
    [mockComment verify];        
}



@end
