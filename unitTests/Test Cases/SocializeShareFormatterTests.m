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

- (void)testFromShare {
    NSString *testKey = @"testKey";
    NSString *testName = @"testName";
    NSString *testText = @"testText";
    
    SocializeShare *share = [[[SocializeShare alloc] init] autorelease];
    SocializeEntity *entity = [[[SocializeEntity alloc] init] autorelease];
    [entity setKey:testKey];
    [entity setName:testName];
    [share setEntity:entity];
    [share setMedium:SocializeShareMediumTwitter];
    [share setText:testText];
    [share setThirdParties:[NSArray arrayWithObject:@"twitter"]];
    
    NSMutableDictionary *testDict = [NSMutableDictionary dictionary];
    SocializeShareJSONFormatter *entityFormatter = [[[SocializeShareJSONFormatter alloc] initWithFactory:_factory] autorelease];
    [entityFormatter toDictionary:testDict fromObject:share];
    NSLog(@"%@", testDict);
    
    NSString *dictKey = [[testDict objectForKey:@"entity"] objectForKey:@"key"];
    NSString *dictName = [[testDict objectForKey:@"entity"] objectForKey:@"name"];
    NSNumber *dictMedium = [testDict objectForKey:@"medium"];
    NSArray *dictThirdParties = [[testDict objectForKey:@"propagation"] objectForKey:@"third_parties"];
    NSNumber *dictText = [testDict objectForKey:@"text"];
    GHAssertEqualStrings(dictKey, testKey, nil);
    GHAssertEqualStrings(dictName, testName, nil);
    GHAssertEquals([dictMedium integerValue], SocializeShareMediumTwitter, nil);
    GHAssertEqualStrings(dictKey, testKey, nil);
    GHAssertEqualObjects(dictThirdParties, [NSArray arrayWithObject:@"twitter"], nil);
    GHAssertEqualStrings(dictText, testText, nil);
}

@end
