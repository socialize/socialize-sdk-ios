//
//  SocializeViewFormatterTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeViewFormatterTests.h"
#import "SocializeView.h"

@implementation SocializeViewFormatterTests

-(void) setUpClass
{
    [super setUpClass];
    _viewFormater = [[SocializeViewJSONFormatter alloc] init];
}

-(void) tearDownClass
{
    [_viewFormater release]; _viewFormater = nil;
    [super tearDownClass];
}

-(void)testToView
{
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/view_single_response.json"];
    NSDictionary * JSONDictionaryToParse =(NSDictionary *)[JSONStringToParse objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    
    id mockView = [OCMockObject mockForProtocol:@protocol(SocializeView)];
    
    [[mockView expect] setObjectID:[[JSONDictionaryToParse objectForKey:@"id"]intValue]];
    [[mockView expect] setLat:((NSNumber*)[JSONDictionaryToParse objectForKey:@"lat"])];
    [[mockView expect] setLng:((NSNumber*)[JSONDictionaryToParse objectForKey:@"lng"])];
    [[mockView expect] setApplication:OCMOCK_ANY];
    [[mockView expect] setUser:OCMOCK_ANY];
    [[mockView expect] setEntity:OCMOCK_ANY];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    [[mockView expect] setDate:[df dateFromString:[JSONDictionaryToParse valueForKey:@"date"]]];
    [df release]; df = nil;
    
    SocializeViewJSONFormatter *viewFormatter = [[[SocializeViewJSONFormatter alloc] initWithFactory:_factory] autorelease];
    [viewFormatter toObject:mockView fromString:JSONStringToParse];
    [mockView verify];
}

@end