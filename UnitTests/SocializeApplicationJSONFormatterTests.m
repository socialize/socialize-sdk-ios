/*
 * SocializeApplicationJSONFormatter.m
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
#import "SocializeApplicationJSONFormatterTests.h"
#import "SocializeApplicationJSONFormatter.h"
#import "SocializeApplication.h"

@implementation SocializeApplicationJSONFormatterTests

- (void)testToApplication
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: 123], @"id", @"test application", @"name", nil];
    id mockApplication = [OCMockObject mockForProtocol:@protocol(SocializeApplication)];
    
    [[mockApplication expect] setObjectID:[[params objectForKey:@"id"]intValue]];
    [[mockApplication expect] setName:[params objectForKey:@"name"]];
    
    SocializeApplicationJSONFormatter* formatter = [[[SocializeApplicationJSONFormatter alloc]initWithFactory:_factory] autorelease];
    [formatter toObject:mockApplication fromDictionary:params];
    [mockApplication verify];
}

- (void)testToApplicationFromString
{
    NSString* jsonApplication = @"{\"id\":123,\"name\":\"test application\"}";
    
    id mockApplication = [OCMockObject mockForProtocol:@protocol(SocializeApplication)];
    
    [[mockApplication expect] setObjectID:123];
    [[mockApplication expect] setName:@"test application"];
    
    SocializeApplicationJSONFormatter* formatter = [[[SocializeApplicationJSONFormatter alloc]initWithFactory:_factory] autorelease];
    [formatter toObject:mockApplication fromString:jsonApplication];
    [mockApplication verify];
}

- (void)testToStringFromApplication
{
    NSString* jsonApplicationExpected = @"{\"id\":123,\"name\":\"test application\"}";
    
    id mockApplication = [OCMockObject mockForProtocol:@protocol(SocializeApplication)];
    
    int ID = 123;
    [[[mockApplication stub] andReturnValue:OCMOCK_VALUE(ID)] objectID];
    [[[mockApplication stub] andReturn:@"test application"] name];
    
    SocializeObjectJSONFormatter* formatter = [[[SocializeApplicationJSONFormatter alloc]initWithFactory:_factory] autorelease];
    GHAssertEqualStrings(jsonApplicationExpected, [formatter toStringfromObject:mockApplication], nil);

}

@end
