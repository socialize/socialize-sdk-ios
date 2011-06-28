//
//  SocializeLikeFormatterTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/27/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeFormatterTests.h"
#import "SocializeLike.h"

@implementation SocializeLikeFormatterTests
-(void) setUpClass
{
    [super setUpClass];
    _likeFormater = [[SocializeLikeJSONFormatter alloc] init];
}

-(void) tearDownClass
{
    [_likeFormater release]; _likeFormater = nil;
    [super tearDownClass];
}

-(void)testToLike
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"like_single_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
/*  id<SocializeApplication> application = [_factory createObjectFromDictionary:[JSONDictionaryToParse objectForKey:@"application"] forProtocol:@protocol(SocializeApplication)];

    id <SocializeUser> user = [_factory createObjectFromDictionary:[JSONDictionaryToParse objectForKey:@"user"] forProtocol:@protocol(SocializeUser)];

    id <SocializeEntity> entity = [_factory createObjectFromDictionary:[JSONDictionaryToParse objectForKey:@"entity"] forProtocol:@protocol(SocializeEntity)];
*/
    
    id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    [[mockLike expect] setLat:[((NSNumber*)[JSONDictionaryToParse objectForKey:@"lat"]) floatValue]];
    [[mockLike expect] setLng:[((NSNumber*)[JSONDictionaryToParse objectForKey:@"lng"]) floatValue]];
    [[mockLike expect] setApplication:OCMOCK_ANY];
    [[mockLike expect] setUser:OCMOCK_ANY];
    [[mockLike expect] setEntity:OCMOCK_ANY];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [[mockLike expect] setDate:[df dateFromString:[JSONDictionaryToParse valueForKey:@"date"]]];
    [df release]; df = nil;
    
    SocializeLikeJSONFormatter *entityFormatter = [[[SocializeLikeJSONFormatter alloc] initWithFactory:_factory] autorelease];
    
    [entityFormatter toObject:mockLike fromString:JSONStringToParse];
    [mockLike verify];
}

/*

-(void)testFromLike
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"like_create.json"];
    NSArray * JSONArrayParse =(NSArray *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    NSString * expectedKeyFieldValue = (NSString *)[[JSONArrayParse objectAtIndex:0]objectForKey:@"lat"];
    NSString * expectedNameFieldValue = (NSString *)[[JSONArrayParse objectAtIndex:0]objectForKey:@"lng"];
    
    id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];
    [[[mockLike expect] andReturn:expectedKeyFieldValue] lat];
    [[[mockLike expect] andReturn:expectedNameFieldValue] lng];
    
    SocializeLikeJSONFormatter * entityFormatter = [[[SocializeLikeJSONFormatter alloc] initWithFactory:_factory] autorelease];
    
    NSMutableDictionary * objectDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    [entityFormatter toDictionary:objectDictionary fromObject:mockLike];
    
    [mockLike verify];
    
    //Verify Dictionary values.
    NSString * actualKeyFieldValue = (NSString *) [objectDictionary valueForKey:@"lat"];
    NSString * actualNameFieldValue = (NSString *) [objectDictionary valueForKey:@"lng"];
    GHAssertEqualStrings(expectedKeyFieldValue, actualKeyFieldValue, @"Entity formatter (toDictionary) - expected keyValue=%@ != actual keyValue=%@", expectedKeyFieldValue, actualKeyFieldValue);
    
    GHAssertEqualStrings(expectedNameFieldValue, actualNameFieldValue, @"Entity formatter (toDictionary) - expected nameValue=%@ != actual nameValue=%@", expectedKeyFieldValue, actualNameFieldValue);
}
*/
@end