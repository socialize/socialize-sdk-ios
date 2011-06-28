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

@implementation SocializeEntityServiceTests


// Run before each test method
- (void)setUp 
{ 
    
    mockfactory  = [OCMockObject mockForClass:[SocializeObjectFactory class]];
    mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeEntityServiceDelegate)];
    
    _entityService = [[SocializeEntityService alloc] initWithProvider:mockProvider 
                                                        objectFactory:mockfactory 
                                                             delegate:mockDelegate];
    
}

// Run after each test method
- (void)tearDown 
{
    
    [_entityService release];
    
}



-(void)testCreateEntity
{
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    
    [[mockEntity expect]setKey:@"Foo"];
    [[mockEntity expect]setName:@"Bar"];
    [[[mockfactory expect]andReturn:mockEntity]createObjectForProtocol:@protocol(SocializeEntity)];
    
    NSString* entityJSONString = @"{\"key\":\"Foo\",\"name\":\"Bar\"}";
    
    [[[mockfactory expect]andReturn:entityJSONString]createStringRepresentationOfArray:[NSArray arrayWithObject:mockEntity]];
    
    NSString* entityJSONStringResponse =  @"[{\"key\":\"Foo\",\"name\":\"Bar\"}]";
    NSData* entityJSONDataResponse = [entityJSONStringResponse  dataUsingEncoding:NSUTF8StringEncoding];
    
    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
    {
        [_entityService request:nil didLoadRawResponse:entityJSONDataResponse];
    };
    
    id mockEntity2 = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    
    NSArray * entityArray = [NSArray arrayWithObjects:mockEntity,mockEntity2, nil];
    
    [[[mockfactory expect]andReturn:entityArray]createObjectFromString:entityJSONStringResponse forProtocol:@protocol(SocializeEntity)];
    
    NSMutableDictionary* params = [_entityService genereteParamsFromJsonString:entityJSONString];
    [[[mockProvider expect]
      andDo:testBlock]
      requestWithMethodName:@"entity/" andParams:params andHttpMethod:@"POST" andDelegate:_entityService];
    
    
    [[mockDelegate expect]entityService:_entityService didReceiveListOfEntities:entityArray];
    
    [_entityService createEntityWithKey:@"Foo" andName:@"Bar"];
    
}
//DuplicateCode
-(void)testSingleCreateEntity
{
    id mockEntity = [OCMockObject niceMockForProtocol:@protocol(SocializeEntity)];
    
    [[mockEntity expect]setKey:@"Foo"];
    [[mockEntity expect]setName:@"Bar"];
    [[[mockfactory expect]andReturn:mockEntity]createObjectForProtocol:@protocol(SocializeEntity)];
    
    NSString* entityJSONString = @"{\"key\":\"Foo\",\"name\":\"Bar\"}";
    
    [[[mockfactory expect]andReturn:entityJSONString]createStringRepresentationOfArray:[NSArray arrayWithObject:mockEntity]];
    
    NSString* entityJSONStringResponse =  @"[{\"key\":\"Foo\",\"name\":\"Bar\"}]";
    NSData* entityJSONDataResponse = [entityJSONStringResponse  dataUsingEncoding:NSUTF8StringEncoding];
    
    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
    {
        [_entityService request:nil didLoadRawResponse:entityJSONDataResponse];
    };
    

    [[[mockfactory expect]andReturn:mockEntity]createObjectFromString:entityJSONStringResponse forProtocol:@protocol(SocializeEntity)];
    
    NSMutableDictionary* params = [_entityService genereteParamsFromJsonString:entityJSONString];
    [[[mockProvider expect]
      andDo:testBlock]
     requestWithMethodName:@"entity/" andParams:params andHttpMethod:@"POST" andDelegate:_entityService];
    
    
    [[mockDelegate expect]entityService:_entityService didReceiveEntity:mockEntity];
    [_entityService createEntityWithKey:@"Foo" andName:@"Bar"];
}



@end
