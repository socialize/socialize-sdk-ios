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


// Run before each test method
- (void)setUp 
{ 
    
    mockfactory  = [OCMockObject mockForClass:[SocializeObjectFactory class]];
    mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    
    _entityService = [[SocializeEntityService alloc] initWithProvider:mockProvider 
                                                        objectFactory:mockfactory 
                                                             delegate:mockDelegate];
    
}

// Run after each test method
- (void)tearDown 
{
    
    [_entityService release];
    
}


/*
-(void)testCreateEntity
{
    id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
  //  id mockRequest = [OCMockObject mockForClass:[SocializeRequest class]];
    
    SocializeRequest*     request = [SocializeRequest getRequestWithParams:nil
                                                          expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                                                  httpMethod:@"POST"
                                                                    delegate:nil
                                                                  requestURL:nil];
  
    
    [[mockEntity expect] setKey:@"Foo"];
    [[mockEntity expect] setName:@"Bar"];
    
    [[[mockfactory expect] andReturn:mockEntity] createObjectForProtocol:@protocol(SocializeEntity)];
    
    NSString* entityJSONString = @"{\"errors\":[], \"items\":[{\"key\":\"Foo\",\"name\":\"Bar\"}]}";
    
    [[[mockfactory expect] andReturn:entityJSONString] createStringRepresentationOfArray:[NSArray arrayWithObject:mockEntity]];
   // [[[mockRequest expect] andReturn:@"POST"] httpMethod];
   // [[[mockRequest expect] andReturn:SocializeDictionaryWIthListAndErrors] expectedJSONFormat];

    NSString* entityJSONStringResponse =  @"{\"errors\":[], \"items\":[{\"key\":\"Foo\",\"name\":\"Bar\"}]}";
    NSData* entityJSONDataResponse = [entityJSONStringResponse  dataUsingEncoding:NSUTF8StringEncoding];
    
    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
    {
        [_entityService request:request didLoadRawResponse:entityJSONDataResponse];
    };
    
    id mockEntity2 = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
    
    NSArray * entityArray = [NSArray arrayWithObjects:mockEntity, mockEntity2, nil];

    [[[mockfactory expect] andReturn:entityArray] createObjectFromString:OCMOCK_ANY forProtocol:OCMOCK_ANY];

    NSMutableDictionary* params = [_entityService genereteParamsFromJsonString:entityJSONString];
    
    [[[mockProvider expect] andDo:testBlock]
      requestWithMethodName:@"entity/" 
        andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors 
        andHttpMethod:@"POST" 
        andDelegate:_entityService];
    
    [[mockDelegate expect] service:_entityService didCreateWithElements:OCMOCK_ANY andErrorList:nil];
    
    [_entityService createEntityWithKey:@"Foo" andName:@"Bar"];

  //  [mockfactory verify];
    [mockDelegate verify];
}

//DuplicateCode

-(void)testSingleCreateEntity
{
    id mockEntity = [OCMockObject niceMockForProtocol:@protocol(SocializeEntity)];
    
    [[mockEntity expect] setKey:@"Foo"];
    [[mockEntity expect] setName:@"Bar"];
    [[[mockfactory expect] andReturn:mockEntity] createObjectForProtocol:@protocol(SocializeEntity)];
    
    NSString* entityJSONString = @"{\"key\":\"Foo\",\"name\":\"Bar\"}";
    
    [[[mockfactory expect] andReturn:entityJSONString] createStringRepresentationOfArray:[NSArray arrayWithObject:mockEntity]];
    
    NSString* entityJSONStringResponse =  @"[{\"key\":\"Foo\",\"name\":\"Bar\"}]";
    NSData* entityJSONDataResponse = [entityJSONStringResponse  dataUsingEncoding:NSUTF8StringEncoding];
    
    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
    {
        [_entityService request:nil didLoadRawResponse:entityJSONDataResponse];
    };
    

    [[[mockfactory expect]andReturn:mockEntity]createObjectFromString:OCMOCK_ANY forProtocol:@protocol(SocializeEntity)];
    
    NSMutableDictionary* params = [_entityService genereteParamsFromJsonString:entityJSONString];

    [[[mockProvider expect]
      andDo:testBlock]
     requestWithMethodName:@"entity/" andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_entityService];
    
//  [[mockDelegate expect]entityService:_entityService didReceiveEntity:mockEntity];
    [[mockDelegate expect] service:_entityService didCreateWithElements:OCMOCK_ANY andErrorList:nil];
    [_entityService createEntityWithKey:@"Foo" andName:@"Bar"];
    [mockDelegate verify];

}
 */

@end
