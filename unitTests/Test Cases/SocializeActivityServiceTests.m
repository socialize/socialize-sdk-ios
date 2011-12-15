/*
 * SocializeActivityServiceTests.m
 * SocializeSDK
 *
 * Created on 10/18/11.
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

#import "SocializeActivityServiceTests.h"
#import "SocializeActivityService.h"
#import "SocializeService+Testing.h"
#import "SocializeLikeService.h"
#import "SocializeActivity.h"

@implementation SocializeActivityServiceTests

-(void)setUpClass
{
    SocializeActivityService* service = [[SocializeActivityService alloc] init];
    _activityService = [[service nonRetainingMock] retain];
    [service release];
}

-(void)tearDownClass
{
    [_activityService release];
}

-(void)getActivityWithResourcePath:(NSString*) path andType: (SocializeActivityType)type
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3], @"first", [NSNumber numberWithInt:5], @"last", nil];
    
    [[_activityService expect]executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:path
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]];
    
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    int identificator = 123;
    
    [[[mockUser stub]andReturnValue:OCMOCK_VALUE(identificator)]objectID];
    
    [_activityService getActivityOfUser:mockUser first:[NSNumber numberWithInt:3] last:[NSNumber numberWithInt:5] activity:type];
    
    [_activityService verify];
    [mockUser verify];
}

-(void)testGetActivityOfCurrentApplication
{    
    [[_activityService expect]executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"activity/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:nil]];
    
    [_activityService getActivityOfCurrentApplication];
    [_activityService verify];
}

-(void)testGetActivityOfCurrentApplicationWithPagination
{   
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3], @"first", [NSNumber numberWithInt:5], @"last", nil];
    
    [[_activityService expect]executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"activity/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]];
    
    [_activityService getActivityOfCurrentApplicationWithFirst:[NSNumber numberWithInt:3] last:[NSNumber numberWithInt:5]];
    [_activityService verify];
}

-(void)testGetActivityOfUser
{    
    [[_activityService expect]executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"user/123/activity/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:nil]];
    id mockUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    int identificator = 123;
    [[[mockUser stub]andReturnValue:OCMOCK_VALUE(identificator)]objectID];
    [_activityService getActivityOfUser:mockUser];
    [_activityService verify];
    [mockUser verify];
}

-(void)testGetAllActivityOfUserWithPagination
{    
    [self getActivityWithResourcePath: @"user/123/activity/" andType: SocializeAllActivity];
}

-(void)testGetCommentActivityOfUserWithPagination
{    
    [self getActivityWithResourcePath: @"user/123/comment/" andType: SocializeCommentActivity];
}

-(void)testGetLikeActivityOfUserWithPagination
{    
    [self getActivityWithResourcePath: @"user/123/like/" andType: SocializeLikeActivity];
}

-(void)testGetViewActivityOfUserWithPagination
{    
    [self getActivityWithResourcePath: @"user/123/view/" andType: SocializeViewActivity];
}

-(void)testGetShareActivityOfUserWithPagination
{    
    [self getActivityWithResourcePath: @"user/123/share/" andType: SocializeShareActivity];
}

-(void) testProtocol
{
    GHAssertTrue([_activityService ProtocolType] == @protocol(SocializeActivity), nil);
}
@end
