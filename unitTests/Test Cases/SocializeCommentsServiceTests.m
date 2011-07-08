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
#import "JSONKit.h"

static const int singleCommentId = 1;

@interface SocializeCommentsServiceTests()
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
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:[NSString stringWithFormat:@"comment/%d/",singleCommentId] andParams:nil  expectedJSONFormat:SocializeDictionary andHttpMethod:@"GET" andDelegate:_service];
    
    _service.provider = mockProvider;   
    
    [_service getCommentById: singleCommentId];
    
    [mockProvider verify];
}

-(void) testGetListOfCommentsById
{    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
     NSArray* ids = [NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];  
    [[mockProvider expect] requestWithMethodName:@"comment/" 
                                       andParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:ids, @"ids", nil]
      expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                   andHttpMethod:@"GET" 
                                     andDelegate:_service];
    _service.provider = mockProvider; 
 
    [_service getCommentsList: ids];
    
    [mockProvider verify];
}

-(void) testGetListOfCommentsByEntityKey
{
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:@"comment/" 
                                       andParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://www.example.com/interesting-story/", @"key", nil]
      expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                   andHttpMethod:@"GET" 
                                     andDelegate:_service];
    _service.provider = mockProvider; 
    
    NSString* entryKey = @"http://www.example.com/interesting-story/";
    [_service getCommentList:entryKey];
    
    [mockProvider verify];
}

-(void) testCreateCommentForExisting
{   
    
    NSArray *params = [NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.example.com/interesting-story/", @"entity", @"this was a great story", @"text", nil],
                       nil];
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:@"comment/" andParams:params  expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_service];
    
    _service.provider = mockProvider;    
    
    SocializeEntity *entity = [[SocializeEntity new] autorelease];  
    entity.key = @"http://www.example.com/interesting-story/";
    entity.name = @"example";
    [_service createCommentForEntity:entity comment:@"this was a great story" createNew:NO];
    
    [mockProvider verify];
}

-(void) testCreateCommentForNew
{   
    SocializeEntity *entity = [[SocializeEntity new] autorelease];  
    entity.key = @"http://www.example.com/interesting-story/";
    entity.name = @"example";
    
    NSArray* mockArray = [NSArray arrayWithObjects:
                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSDictionary dictionaryWithObjectsAndKeys:entity.key, @"key", entity.name, @"name", nil],@"entity",
                                      @"this was a great story", @"text", nil], 
                                     nil];
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:@"comment/" andParams:mockArray  expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_service];
    
    _service.provider = mockProvider;    

    [_service createCommentForEntity:entity comment:@"this was a great story" createNew:YES];
    
    [mockProvider verify];
}

#pragma mark response tests
-(void) testServiceFailed
{
    [_service request:nil didFailWithError:_testError];
}

-(void) testServiceReceiveSingleComment
{
    NSString* jsonResponse = [self helperGetJSONStringFromFile:@"responses/comment_single_response.json"];
    NSData* jsonData = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    [_service request:nil didLoadRawResponse:jsonData];
}

-(void) testServiceReceiveCommentsList
{
    NSString* jsonResponse = [self helperGetJSONStringFromFile:@"responses/comment_list_response.json"];
    NSData* jsonData = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    [_service request:nil didLoadRawResponse:jsonData];
}

#pragma mark Socialize comment service delegate

-(void) receivedComment: (SocializeCommentsService*)service comment:(id<SocializeComment>)comment
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


-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName
{
    NSString * JSONFilePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",@"JSON-RequestAndResponse-TestFiles", fileName ] ofType:nil];
    
    
    NSString * JSONString = [NSString stringWithContentsOfFile:JSONFilePath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
    
    return  JSONString;
}
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    NSLog(@"didCreate %@", object);
}

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    NSLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    NSLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFetch:(id<SocializeObject>)object{
    NSLog(@"didFetch %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"didFail %@", error);
}

-(void)service:(SocializeService*)service didCreateWithElements:(NSArray*)dataArray andErrorList:(id)errorList{
    NSLog(@"didCreateWithElements %@", dataArray);
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray andErrorList:(id)errorList{
    NSLog(@"didFetchElements %@", dataArray);
}

@end
