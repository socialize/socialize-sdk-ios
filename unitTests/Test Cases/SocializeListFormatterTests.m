/*
 * SocializeListFormatterTests.m
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

#import "SocializeListFormatter.h"
#import "SocializeListFormatterTests.h"
#import "SocializeEntity.h"
#import "SocializeObjects.h"
#import "JSONKit.h"


@implementation SocializeListFormatterTests


- (void)testToRepresentationArrayFromObjectArray
{
 
    id mockSocializeObject1 = [OCMockObject mockForProtocol:@protocol(SocializeObject)];
    id mockSocializeObject2 = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
 
    
    NSDictionary * dictionary1 = [NSDictionary dictionaryWithObject:@"mockSocializeObject1Key" forKey:@"key"];
    NSDictionary * dictionary2 = [NSDictionary dictionaryWithObject:@"mockSocializeObject2Key" forKey:@"key"];
    
    int intValue = 2;
    
    id mockFactory = [self mockFactory];
    [[[mockFactory expect]andReturn:dictionary1]createDictionaryRepresentationOfObject:mockSocializeObject1];
    [[[mockFactory expect]andReturn:dictionary2]createDictionaryRepresentationOfObject:mockSocializeObject2];
    
    SocializeListFormatter * listFormatter = [[[SocializeListFormatter alloc]initWithFactory:mockFactory] autorelease];
    
    
    NSArray * entitiesArray = [NSArray arrayWithObjects:mockSocializeObject1, mockSocializeObject2,[NSNumber numberWithInt:intValue] ,nil];
    
    NSMutableArray * testArrayRepresentation = [NSMutableArray arrayWithCapacity:10];
    [listFormatter toRepresentationArray:testArrayRepresentation fromArray:entitiesArray];
    
   
    GHAssertEquals([testArrayRepresentation count],(NSUInteger)3 , @"Should be exactly three items in array");
    
    GHAssertEqualObjects([testArrayRepresentation objectAtIndex:0],dictionary1 , @"objects should be equal");
    
    GHAssertEqualObjects([testArrayRepresentation objectAtIndex:1],dictionary2 , @"objects should be equal");
   
    GHAssertEquals([[testArrayRepresentation objectAtIndex:2]intValue], intValue, @"values should be equal");
    
    
   
}

- (void)testToRepresentationStringFromObjectArray
{
    id mockSocializeObject1 = [OCMockObject mockForProtocol:@protocol(SocializeObject)];
    id mockSocializeObject2 = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    
    
    NSDictionary * dictionary1 = [NSDictionary dictionaryWithObject:@"mockSocializeObject1Key" forKey:@"key"];
    NSDictionary * dictionary2 = [NSDictionary dictionaryWithObject:@"mockSocializeObject2Key" forKey:@"key"];
    
    int intValue = 2;
    
    id mockFactory = [self mockFactory];
    [[[mockFactory expect]andReturn:dictionary1]createDictionaryRepresentationOfObject:mockSocializeObject1];
    [[[mockFactory expect]andReturn:dictionary2]createDictionaryRepresentationOfObject:mockSocializeObject2];
    
    SocializeListFormatter * listFormatter = [[[SocializeListFormatter alloc]initWithFactory:mockFactory] autorelease];
    
    
    NSArray * entitiesArray = [NSArray arrayWithObjects:mockSocializeObject1, mockSocializeObject2,[NSNumber numberWithInt:intValue] ,nil];
    
    NSString * actualString = [listFormatter toRepresentationStringfromArray:entitiesArray];
    
    NSString * expectedString = [[NSArray arrayWithObjects:dictionary1,dictionary2,[NSNumber numberWithInt:intValue] ,nil]JSONString];
    
    GHAssertEqualStrings(expectedString, actualString,@"Strings not equal");
    
  
    
}
//- (void)testToRepresentationArrayFromObjectArrayWithBadValues
//{
//    
//    NSObject * badObject = [[NSObject new]autorelease];
//    
//    NSArray * entitiesArray = [NSArray arrayWithObjects:badObject, nil];
//    
//    id mockFactory = [self mockFactory];
//    SocializeListFormatter * listFormatter = [[[SocializeListFormatter alloc]initWithFactory:mockFactory] autorelease];
//    
//    NSMutableArray * testArrayRepresentation = [NSMutableArray arrayWithCapacity:1];
//    [listFormatter toRepresentationArray:testArrayRepresentation fromArray:entitiesArray];
//    
//    
//    
//}


- (void)testToRepresentationStringFromObjectArrayWithBadObject
{
    
    NSObject * badObject = [[NSObject new]autorelease];
    
    NSArray * badObjectArray = [NSArray arrayWithObjects:badObject, nil];
    
    id mockFactory = [self mockFactory];
    SocializeListFormatter * listFormatter = [[[SocializeListFormatter alloc]initWithFactory:mockFactory] autorelease];
    
    GHAssertThrows([listFormatter toRepresentationStringfromArray:badObjectArray], @"Should throw exception");


}


-(void)testToObjectFromStringActivity
{
    id mockFactory = [self mockFactory];
    id mockForComment = [OCMockObject mockForProtocol: @protocol(SocializeComment)];
    [[[mockFactory stub] andReturn:mockForComment] createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeComment)];
    id mockForLike = [OCMockObject mockForProtocol: @protocol(SocializeComment)];
    [[[mockFactory stub] andReturn:mockForLike] createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeLike)];
    id mockForView = [OCMockObject mockForProtocol: @protocol(SocializeView)];
    [[[mockFactory stub] andReturn:mockForView] createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeView)];
    id mockForShare = [OCMockObject mockForProtocol: @protocol(SocializeView)];
    [[[mockFactory stub] andReturn:mockForShare] createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeShare)];
    id mockForObject = [OCMockObject mockForProtocol: @protocol(SocializeView)];
    [[[mockFactory stub] andReturn:mockForObject] createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeObject)];
    
    SocializeListFormatter* listFormatter = [[[SocializeListFormatter alloc] initWithFactory:mockFactory]autorelease];
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/activity_response.json"];
    id res = [listFormatter toObjectfromString:JSONStringToParse forProtocol:@protocol(SocializeActivity)];
    GHAssertTrue([res count] == 5, nil);
    
    [mockFactory verify];
}

-(void)testToObjectFromStringComments
{
    id mockFactory = [self mockFactory];
    id mockForComment = [OCMockObject mockForProtocol: @protocol(SocializeComment)];
    [[[mockFactory stub] andReturn:mockForComment] createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeComment)];
    [[[mockFactory stub] andReturn:mockForComment] createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeComment)];
    
    SocializeListFormatter* listFormatter = [[[SocializeListFormatter alloc] initWithFactory:mockFactory]autorelease];
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/comment_list_response.json"];
    id res = [listFormatter toObjectfromString:JSONStringToParse forProtocol:@protocol(SocializeComment)];
    GHAssertTrue([res count] == 2, nil);
    
    [mockFactory verify];
}
@end
