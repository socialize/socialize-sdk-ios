//
//  SocializeEntityServiceTests.m
//  SocializeSDK
//
//  Created by William M. Johnson on 6/22/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeEntityServiceTests.h"
#import "SocializeObjectFactory.h"
#import "SocializeProvider.h"
#import "SocializeRequest.h"

@implementation SocializeEntityServiceTests

-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName
{
    NSString * JSONFilePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",@"JSON-RequestAndResponse-TestFiles", fileName ] ofType:nil];
    
    NSString * JSONString = [NSString stringWithContentsOfFile:JSONFilePath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
    
    return  JSONString;
}

// Run before each test method
- (void)setUp 
{ 
    
    _mockFactory = [OCMockObject niceMockForClass:[SocializeObjectFactory class]];   
    _entityService = [[SocializeEntityService alloc] initWithProvider:nil 
                                                        objectFactory:_mockFactory 
                                                             delegate:nil];
    
}

// Run after each test method
- (void)tearDown 
{
    [_entityService release]; _entityService = nil;
}

- (id) createMockEntiry: (NSString *) entityKey entityName: (NSString *) entityName
{
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];

    [[mockEntity expect]setKey:entityKey];
    [[mockEntity expect]setName:entityName];
    
    return mockEntity;
}
- (void) configurateMockFactoryForCreateEntityWithKey: (id) mockEntity
{
    NSArray* entitis = [NSArray arrayWithObject:mockEntity];    
    [[[_mockFactory stub] andReturn:mockEntity]createObjectForProtocol:@protocol(SocializeEntity)];
    [[[_mockFactory stub] andReturn:@"some_request"]createStringRepresentationOfArray:entitis];
}

- (id) createMockProvider 
{
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:@"entity/" andParams:OCMOCK_ANY expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_entityService];
    
    return mockProvider;
}

-(void)testCreateEntityWithKey
{
    NSString* entityKey = @"www.google.com";
    NSString* entityName = @"google";
    
    id mockEntity = [self createMockEntiry: entityKey entityName: entityName];
    [self configurateMockFactoryForCreateEntityWithKey: mockEntity];
 
    id mockProvider = [self createMockProvider];
    _entityService.provider = mockProvider;
    
    [_entityService createEntityWithKey:entityKey andName:entityName];
    
    [mockProvider verify];
    [mockEntity verify];
    [_mockFactory verify];
}

-(void)testGetEntityWithKey
{
    NSString* entityKey = @"www.google.com";
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:entityKey,@"entity_key", nil];
    [[mockProvider expect] requestWithMethodName:@"entity/" andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:_entityService];

    _entityService.provider = mockProvider;
    
    [_entityService entityWithKey:entityKey];
    [mockProvider verify];
}

-(void)testCreateEntityCallback{
    
    SocializeRequest* _request = [SocializeRequest getRequestWithParams:nil expectedJSONFormat:SocializeDictionary httpMethod:@"POST"  delegate:nil requestURL:@"invalidparam"];
    
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/entity_single_response.json"];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    [[mockDelegate expect] service:_entityService didCreate:OCMOCK_ANY];

    _entityService.delegate = [mockDelegate retain];

    id mockEntity = [OCMockObject niceMockForProtocol:@protocol(SocializeEntity)];
    [[[_mockFactory stub]andReturn:mockEntity]createObjectFromString:JSONStringToParse forProtocol:@protocol(SocializeEntity)]; 
    
    [_entityService request:_request didLoadRawResponse:[JSONStringToParse dataUsingEncoding:NSUTF8StringEncoding]];
    [mockDelegate verify];
}

@end
