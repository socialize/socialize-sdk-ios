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
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"share_single_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    id mockshare = [OCMockObject mockForProtocol:@protocol(SocializeShare)];
    
    [[mockshare expect] setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
//    [[mockshare expect] setText:[JSONDictionaryToParse objectForKey:@"text"]];
//    [[mockshare expect] setMedium:[((NSNumber*)[JSONDictionaryToParse objectForKey:@"medium"]) intValue]];
//    [[mockshare expect] setLat:[JSONDictionaryToParse objectForKey:@"lat"]];
//   [[mockshare expect] setLng:[JSONDictionaryToParse objectForKey:@"lng"]];
    [[mockshare expect] setText:OCMOCK_ANY];
    [[mockshare expect] setMedium:0];
    [[mockshare expect] setLat:OCMOCK_ANY];
    [[mockshare expect] setLng:OCMOCK_ANY];
    
    [[mockshare expect] setApplication:OCMOCK_ANY];
    [[mockshare expect] setUser:OCMOCK_ANY];
    [[mockshare expect] setEntity:OCMOCK_ANY];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [[mockshare expect] setDate:[df dateFromString:[JSONDictionaryToParse valueForKey:@"date"]]];
    [df release]; df = nil;
    
    SocializeShareJSONFormatter *entityFormatter = [[[SocializeShareJSONFormatter alloc] initWithFactory:_factory] autorelease];
    [entityFormatter toObject:mockshare fromString:JSONStringToParse];
    [mockshare verify];
}

@end
