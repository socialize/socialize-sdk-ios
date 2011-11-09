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
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/like_single_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    id mockLike = [OCMockObject mockForProtocol:@protocol(SocializeLike)];

    [[mockLike expect] setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    [[mockLike expect] setLat:((NSNumber*)[JSONDictionaryToParse objectForKey:@"lat"])];
    [[mockLike expect] setLng:((NSNumber*)[JSONDictionaryToParse objectForKey:@"lng"])];
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

@end