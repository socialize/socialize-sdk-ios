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
#import "SocializeLike.h"


@interface SocializeLikeTests() 
-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName;
@end

@implementation SocializeLikeTests

-(void) setUpClass
{  
    SocializeObjectFactory* factory = [[SocializeObjectFactory new] autorelease];
    _service = [[SocializeLikeService alloc] initWithProvider:nil objectFactory:factory delegate:self];
    _testError = [NSError errorWithDomain:@"Socialize" code: 400 userInfo:nil];
}

-(void) tearDownClass
{
    [_service release]; _service = nil;
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
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    id<SocializeLike> mockLike = [objectCreator createObjectForProtocol:@protocol(SocializeLike)]; 

    [mockLike setObjectID:alikeId];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:alikeId], @"id",
                                   nil];
    
    id mockProvider =[OCMockObject mockForClass:[SocializeProvider class]];

    _service.provider = mockProvider; 
    
    NSString* newMethodName = [NSString stringWithFormat:@"like/%d/", alikeId];
    [[mockProvider expect] requestWithMethodName:newMethodName andParams:params andHttpMethod:@"DELETE" andDelegate:_service];
    [_service deleteLike: mockLike];
    [mockProvider verify];
}

-(void) testGetListOfLikes
{
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"www.123.com", @"key",
                                   nil];

    [[mockProvider expect] requestWithMethodName:@"like/" andParams:params andHttpMethod:@"GET" andDelegate:_service];
    [_service getLikesForEntityKey:@"www.123.com"];
    [mockProvider verify];
}

-(void)testpostLikeForEntity{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";

    NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, @"entity", nil];
    NSArray *params = [NSArray arrayWithObjects:entityParam, 
                       nil];

    [[mockProvider expect] requestWithMethodName:@"like/" andParams:params andHttpMethod:@"POST" andDelegate:_service];

    [_service postLikeForEntity:mockEntity];
    [mockProvider verify];
}

-(void)testGetLikesCallback{
    
    SocializeRequest* _request = [SocializeRequest getRequestWithParams:nil httpMethod:@"POST" delegate:self requestURL:@"invalidparam"];

    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/like_single_response.json"];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeLikeServiceDelegate)];
    _service.delegate = mockDelegate;
    
    [[mockDelegate expect] didPostLike:_service like:OCMOCK_ANY];
    
    [_service request:_request didLoadRawResponse:[JSONStringToParse dataUsingEncoding:NSUTF8StringEncoding]];
    [mockDelegate verify];

}

-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName
{
    NSString * JSONFilePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",@"JSON-RequestAndResponse-TestFiles", fileName ] ofType:nil];
    
    NSString * JSONString = [NSString stringWithContentsOfFile:JSONFilePath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
    
    return  JSONString;
}


-(void)didPostLike:(id)service like:(id)data{

}

-(void)didDeleteLike:(id)service like:(id)data{

}

-(void)didFetchLike:(id)service like:(id)data{

}

-(void)didFailService:(id)service error:(NSError*)error{
    
}

@end
