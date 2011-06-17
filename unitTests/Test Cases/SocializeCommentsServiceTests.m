/*
 * SocializeCommentsServiceTests.m
 * SocializeSDK
 *
 * Created on 6/17/11.
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
#import "SocializeCommentsServiceTests.h"
#import "SocializeComment.h"
#import "SocializeProvider.h"
#import "SocializeCommentJSONFormatter.h"

#import <Foundation/Foundation.h>

static const int singleCommentId = 1;

@interface SocializeCommentsServiceTests()
    -(NSMutableDictionary*) dictionaryFromJSON: (NSString*) jsonRequstString;
    - (id) MockProviderForGetListOfCommon: (NSString *) jsonRequstString method: (NSString *)method httpMethod: (NSString*) httpMethod;
    - (id) MockCommentFormaterFotGetListOfComments: (NSArray *) ids jsonRequstString: (NSString *) jsonRequstString;
    - (id) MockCommentFormaterFotGetListOfCommentsByKey: (NSString*) entryKey jsonRequstString: (NSString *) jsonRequstString;
    - (id) MockCommentFormaterFotPostComments:params jsonRequstString: jsonRequstString;
@end

@implementation SocializeCommentsServiceTests

-(void) setUpClass
{
    // TODO:: change init steps
    _service = [[SocializeCommentsService alloc] init];
}

-(void) tearDownClass
{
    [_service release]; _service = nil;
}

-(void) testSendGetCommentById
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:singleCommentId], @"id",
                                   nil];
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:@"comment/" andParams:params andHttpMethod:@"GET" andDelegate:_service];
    
    _service.provider = mockProvider;   
    
    [_service getCommentById: singleCommentId];
    
    [mockProvider verify];
}


-(void) testGetListOfCommentsById
{
    NSString* jsonRequstString = @"{/'ids/': [1,2]}";
    id mockProvider = [self MockProviderForGetListOfCommon: jsonRequstString method: @"comment/list/" httpMethod:@"POST"];
    
    _service.provider = mockProvider; 
    
    NSArray* ids = [NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
    id mockCommentJsonFormater = [self MockCommentFormaterFotGetListOfComments: ids jsonRequstString: jsonRequstString];   
    _service.commentFormater = mockCommentJsonFormater;
    
    [_service getCommentsList: ids];
    
    [mockProvider verify];
    [mockCommentJsonFormater verify];
}

-(void) testGetListOfCommentsByEntityKey
{
    NSString* jsonRequstString = @"{/'key/': /'http://www.example.com/interesting-story/'}";
    id mockProvider = [self MockProviderForGetListOfCommon: jsonRequstString method: @"comment/list/" httpMethod:@"POST"];
    
    _service.provider = mockProvider; 
    
    NSString* entryKey = @"http://www.example.com/interesting-story/";
    id mockCommentJsonFormater = [self MockCommentFormaterFotGetListOfCommentsByKey:entryKey jsonRequstString: jsonRequstString];   
    _service.commentFormater = mockCommentJsonFormater;
    
    [_service getCommentList:entryKey];
    
    [mockProvider verify];
    [mockCommentJsonFormater verify];
}

-(void) testCreateCommentForExistingEntity
{   
    NSString* jsonRequstString = @"[ {/'entity/': /'http://www.example.com/interesting-story//', /'text/': /'this was a great story/'}]";
    id mockProvider = [self MockProviderForGetListOfCommon: jsonRequstString method: @"comment/" httpMethod:@"PUT"];
    _service.provider = mockProvider;    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"this was a great story", @"http://www.example.com/interesting-story/",
                            nil];

    id mockCommentJsonFormater = [self MockCommentFormaterFotPostComments:params jsonRequstString: jsonRequstString];   
    _service.commentFormater = mockCommentJsonFormater;
    
    [_service postComments:params];
    
    [mockProvider verify];
    [mockCommentJsonFormater verify];
}

#pragma mark helper methods

-(NSMutableDictionary*) dictionaryFromJSON: (NSString*) jsonRequstString
{
    NSData* jsonData = [NSData dataWithBytes:[jsonRequstString UTF8String] length:[ jsonRequstString length]];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            jsonData, @"jsonData",
            nil];
}

- (id) MockProviderForGetListOfCommon: (NSString *) jsonRequstString method: (NSString *)method httpMethod: (NSString*) httpMethod
{
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:method andParams:[self dictionaryFromJSON:jsonRequstString] andHttpMethod:httpMethod andDelegate:_service];
    return mockProvider;
}

- (id) MockCommentFormaterFotGetListOfComments: (NSArray *) ids jsonRequstString: (NSString *) jsonRequstString 
{
    id mockCommentJsonFormater = [OCMockObject mockForClass:[SocializeCommentJSONFormatter class]];
    [[[mockCommentJsonFormater stub] andReturn:jsonRequstString] commentIdsToJsonString:ids];
           
    return mockCommentJsonFormater;
}

-(id) MockCommentFormaterFotGetListOfCommentsByKey: (NSString*) entryKey jsonRequstString: (NSString *) jsonRequstString 
{
    id mockCommentJsonFormater = [OCMockObject mockForClass:[SocializeCommentJSONFormatter class]];
    [[[mockCommentJsonFormater stub] andReturn:jsonRequstString] entryKeyToJsonString:entryKey];
    
    return mockCommentJsonFormater;
}

-(id) MockCommentFormaterFotPostComments:params jsonRequstString: jsonRequstString
{
    id mockCommentJsonFormater = [OCMockObject mockForClass:[SocializeCommentJSONFormatter class]];
    [[[mockCommentJsonFormater stub] andReturn:jsonRequstString] commentsFromDictionary:params];
    
    return mockCommentJsonFormater;
}

@end
