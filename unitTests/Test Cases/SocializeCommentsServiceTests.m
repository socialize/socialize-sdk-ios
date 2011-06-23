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
#import "SocializeObjectFactory.h"

#import <Foundation/Foundation.h>

static const int singleCommentId = 1;

@interface SocializeCommentsServiceTests()
    -(NSMutableDictionary*) dictionaryFromJSON: (NSString*) jsonRequstString;
    - (id) MockProviderForGetListOfCommon: (NSString *) jsonRequstString method: (NSString *)method httpMethod: (NSString*) httpMethod;
    -(NSString *)helperGetJSONStringFromFile:(NSString *)fileName;
@end

@implementation SocializeCommentsServiceTests

-(void) setUpClass
{  
    SocializeObjectFactory* factory = [[SocializeObjectFactory new] autorelease] ;
    _service = [[SocializeCommentsService alloc] initWithProvider:nil objectFactory:factory delegate:self];
    
    _testError = [NSError errorWithDomain:@"" code: 402 userInfo:nil];
}

-(void) tearDownClass
{
    [_service release]; _service = nil;
}

#pragma mark - Requests test

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
    NSString* jsonRequstString = @"{\"ids\":[1,2]}";
    id mockProvider = [self MockProviderForGetListOfCommon: jsonRequstString method: @"comment/list/" httpMethod:@"POST"];
    
    _service.provider = mockProvider; 
    
    NSArray* ids = [NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];   
    [_service getCommentsList: ids];
    
    [mockProvider verify];
}

-(void) testGetListOfCommentsByEntityKey
{
    NSString* jsonRequstString = @"{\"key\":\"http://www.example.com/interesting-story/\"}";
    id mockProvider = [self MockProviderForGetListOfCommon: jsonRequstString method: @"comment/list/" httpMethod:@"POST"];
    
    _service.provider = mockProvider; 
    
    NSString* entryKey = @"http://www.example.com/interesting-story/";
    [_service getCommentList:entryKey];
    
    [mockProvider verify];
}

-(void) testCreateCommentForExistingEntity
{   
    NSString* jsonRequstString = @"[{\"entity\":\"http://www.example.com/interesting-story/\",\"text\":\"this was a great story\"}]";
    id mockProvider = [self MockProviderForGetListOfCommon: jsonRequstString method: @"comment/" httpMethod:@"PUT"];
    _service.provider = mockProvider;    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"this was a great story", @"http://www.example.com/interesting-story/",
                            nil];
   
    [_service postComments:params];
    [mockProvider verify];
}

#pragma mark response tests
-(void) testServiceFailed
{
    [_service request:nil didFailWithError:_testError];
}

-(void) testServiceReceiveSingleComment
{
    NSString* jsonResponse = [self helperGetJSONStringFromFile:@"comment_single_response.json"];
    NSData* jsonData = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    [_service request:nil didLoadRawResponse:jsonData];
}

-(void) testServiceReceiveCommentsList
{
    NSString* jsonResponse = [self helperGetJSONStringFromFile:@"comment_list_response.json"];
    NSData* jsonData = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    [_service request:nil didLoadRawResponse:jsonData];
}

#pragma mark Socialize comment service delegate

-(void) receivedComment: (SocializeCommentsService*)service comment: (id<SocializeComment>) comment
{ 
    GHAssertEquals(comment.objectID, 1, nil);
    GHAssertEqualStrings(comment.entity.key, @"http://www.example.com/interesting-story/", nil);
    GHAssertEqualStrings(comment.application.name, @"My App", nil);
    GHAssertEqualStrings(comment.user.userName, @"msocialize", nil);
    GHAssertEqualStrings(comment.text, @"this was a great story", nil);
}

-(void) receivedComments: (SocializeCommentsService*)service comments: (NSArray*) comments
{
    GHAssertTrue(comments.count == 2, nil);
}

-(void) didFailService:(SocializeCommentsService*)service withError: (NSError *)error;
{
    GHAssertEqualObjects(_testError, error, nil);
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

-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName
{
    NSString * JSONFilePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",@"JSON-RequestAndResponse-TestFiles", fileName ] ofType:nil];
    
    
    NSString * JSONString = [NSString stringWithContentsOfFile:JSONFilePath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
    
    return  JSONString;
}

@end
