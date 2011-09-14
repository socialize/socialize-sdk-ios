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
#import "SocializeCommonDefinitions.h"
#import "SocializeObjectFactory.h"
#import "SocializeLike.h"


#define ENTITY @"entity_key"

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
    [[mockProvider expect] requestWithMethodName:newMethodName andParams:params  expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:_service];
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
    [[mockProvider expect] requestWithMethodName:newMethodName andParams:params  expectedJSONFormat:SocializeAny andHttpMethod:@"DELETE" andDelegate:_service];
    [_service deleteLike: mockLike];
    [mockProvider verify];
}

-(void) testGetListOfLikes
{
    NSNumber* first = [NSNumber numberWithInt:1];
    NSNumber* last = [NSNumber numberWithInt:100];
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    _service.delegate = nil;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"www.123.com", @"entity_key", first, @"first", last, @"last",
                                   nil];

    [[mockProvider expect] requestWithMethodName:@"like/" andParams:params  expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:_service];

    [_service getLikesForEntityKey:@"www.123.com" first:first last:last];
    [mockProvider verify];
}

-(void) testGetListOfLikesWithNilPageIndicators
{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"www.123.com", @"entity_key", 
                                   nil];
    
    [[mockProvider expect] requestWithMethodName:@"like/" andParams:params  expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:_service];
    
    [_service getLikesForEntityKey:@"www.123.com" first:nil last:nil];
    [mockProvider verify];
}


-(void)testpostLikeForEntity{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";

    NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, ENTITY, nil];
    NSArray *params = [NSArray arrayWithObjects:entityParam, 
                       nil];

    [[mockProvider expect] requestWithMethodName:@"like/" andParams:params  expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_service];

    [_service postLikeForEntity:mockEntity andLongitude:nil latitude:nil];
    [mockProvider verify];
}

-(void)testpostLikeForEntityWithGeo{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    NSNumber* lng = [NSNumber numberWithFloat:-122.397850];
    NSNumber* lat = [NSNumber numberWithFloat:37.786521];
    
    NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, ENTITY, lng, @"lng", lat, @"lat", nil];
    NSArray *params = [NSArray arrayWithObjects:entityParam, 
                       nil];
    
    [[mockProvider expect] requestWithMethodName:@"like/" andParams:params  expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_service];
    
    [_service postLikeForEntity:mockEntity andLongitude:lng latitude:lat];
    [mockProvider verify];
}

-(void)testGetLikesCallback{
    
    SocializeRequest* _request = [SocializeRequest getRequestWithParams:nil expectedJSONFormat:SocializeDictionary httpMethod:@"GET"  delegate:self requestURL:@"invalidparam"];

    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/like_single_response.json"];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    _service.delegate = [mockDelegate retain];
    
    [[mockDelegate expect] service:_service didFetchElements:OCMOCK_ANY];
    
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



-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    NSLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    NSLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFetch:(id<SocializeObject>)object{
    NSLog(@"didFetch %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"didFail %@", error);
}

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)objectCreated{
    NSLog(@"didCreateWithElements %@", objectCreated);
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    NSLog(@"didFetchElements %@", dataArray);
}

@end
