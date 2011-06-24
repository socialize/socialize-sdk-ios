//
//  SocializeLikeTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/23/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeLikeTests.h"
#import "SocializeLikeService.h"
#import <OCMock/OCMock.h>
#import "Socialize.h"
#import "NSMutableData+PostBody.h"
#import "SocializeCommonDefinitions.h"

#import "SocializeObjectFactory.h"

@implementation SocializeLikeTests

-(void) setUpClass
{  
    SocializeObjectFactory* factory = [[SocializeObjectFactory new] autorelease];
    _service = [[SocializeLikeService alloc] initWithProvider:nil objectFactory:factory delegate:self];
    _testError = [NSError errorWithDomain:@"Socialize" code: 400 userInfo:nil];
}

-(void) tearDownClass
{
   // [_service release]; _service = nil;
}

-(void) testGetAlike
{
    NSInteger alikeId = 54;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:alikeId], @"id",
                                   nil];

    id mockProvider =[OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider; 
    
    NSString* newMethodName = [NSString stringWithFormat:@"like/%d/", alikeId];
    [[mockProvider expect] requestWithMethodName:newMethodName andParams:params andHttpMethod:@"GET" andDelegate:_service];
    [_service getLike:alikeId];
    [mockProvider verify];
}

-(void) testDeleteAlike
{
    NSInteger alikeId = 54;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:alikeId], @"id",
                                   nil];
    
    id mockProvider =[OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider; 
    
    NSString* newMethodName = [NSString stringWithFormat:@"like/%d/", alikeId];
    [[mockProvider expect] requestWithMethodName:newMethodName andParams:params andHttpMethod:@"DELETE" andDelegate:_service];
    [_service deleteLike:alikeId];
    [mockProvider verify];
}

-(void) testGetListOfLikes
{
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"www.123.com", @"key",
                                   nil];

    [[mockProvider expect] requestWithMethodName:@"likes/" andParams:params andHttpMethod:@"GET" andDelegate:_service];
    [_service getLikesForEntityKey:@"www.123.com"];
    [mockProvider verify];
}

-(void)testpostLikeForEntity{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [mockEntity key], @"entity",
                                   nil];

    [[mockProvider expect] requestWithMethodName:@"likes/" andParams:params andHttpMethod:@"POST" andDelegate:_service];
    [_service postLikeForEntity:mockEntity];
    [mockProvider verify];
}


-(void)didSucceed:(id)service data:(id)data{
    
}

-(void)didFailService:(id)service error:(NSError*)error{
    
}

@end
