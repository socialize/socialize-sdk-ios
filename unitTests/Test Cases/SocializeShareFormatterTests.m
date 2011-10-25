//
//  SocializeShareFormatterTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareFormatterTests.h"
#import "SocializeShare.h"

@implementation SocializeShareFormatterTests
-(void) setUpClass
{
    [super setUpClass];
    _shareFormater = [[SocializeShareJSONFormatter alloc] init];
}

-(void) tearDownClass
{
    [_shareFormater release]; _shareFormater = nil;
    [super tearDownClass];
}

-(void)testToshare
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/share_single_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    id mockShare = [OCMockObject mockForProtocol:@protocol(SocializeShare)];
    
    [[mockShare expect] setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    [[mockShare expect] setLat:((NSNumber*)[JSONDictionaryToParse objectForKey:@"lat"])];
    [[mockShare expect] setLng:((NSNumber*)[JSONDictionaryToParse objectForKey:@"lng"])];
    [[mockShare expect] setText:[JSONDictionaryToParse objectForKey:@"text"]];
    [[mockShare expect] setMedium:[[[JSONDictionaryToParse objectForKey:@"medium"] objectForKey:@"id"]intValue]];
    
    [[mockShare expect] setApplication:OCMOCK_ANY];
    [[mockShare expect] setUser:OCMOCK_ANY];
    [[mockShare expect] setEntity:OCMOCK_ANY];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [[mockShare expect] setDate:[df dateFromString:[JSONDictionaryToParse valueForKey:@"date"]]];
    [df release]; df = nil;
    
    SocializeShareJSONFormatter *entityFormatter = [[[SocializeShareJSONFormatter alloc] initWithFactory:_factory] autorelease];
    [entityFormatter toObject:mockShare fromString:JSONStringToParse];
    [mockShare verify];
}

@end
