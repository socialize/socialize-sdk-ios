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
    _service = [[SocializeLikeService alloc] initWithObjectFactory:factory delegate:self];
    _mockService = [[_service nonRetainingMock] retain];

    _testError = [NSError errorWithDomain:@"Socialize" code: 400 userInfo:nil];
}

-(void) tearDownClass
{
    [_mockService release]; _mockService = nil;
    [_service release]; _service = nil;
}

-(void) testGetAlike
{
    NSInteger alikeId = 54;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:alikeId], @"id",
                                   nil];

    NSString* newMethodName = [NSString stringWithFormat:@"like/%d/", alikeId];
    SocializeRequest *expectedRequest = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:newMethodName expectedJSONFormat:SocializeDictionaryWithListAndErrors params:params];
    [[_mockService expect] executeRequest:expectedRequest];

    [_mockService getLike:alikeId];
    [_mockService verify];
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
    
    NSString* newMethodName = [NSString stringWithFormat:@"like/%d/", alikeId];
    SocializeRequest *expectedRequest = [SocializeRequest requestWithHttpMethod:@"DELETE" resourcePath:newMethodName expectedJSONFormat:SocializeAny params:params];
    [[_mockService expect] executeRequest:expectedRequest];

    [_mockService deleteLike: mockLike];
    [_mockService verify];
}

-(void) testGetListOfLikes
{
    NSNumber* first = [NSNumber numberWithInt:1];
    NSNumber* last = [NSNumber numberWithInt:100];
    
    _service.delegate = nil;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"www.123.com", @"entity_key", first, @"first", last, @"last",
                                   nil];

    [[_mockService expect] executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"like/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]];

    [_mockService getLikesForEntityKey:@"www.123.com" first:first last:last];
    [_mockService verify];
}

-(void) testGetListOfLikesWithNilPageIndicators
{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"www.123.com", @"entity_key", 
                                   nil];
    
    [[_mockService expect] executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"like/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]];

    [_mockService getLikesForEntityKey:@"www.123.com" first:nil last:nil];
    [_mockService verify];
}

-(void)testpostLikeForEntity{
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";

    NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, ENTITY, nil];
    NSArray *params = [NSArray arrayWithObjects:entityParam, 
                       nil];

    [[_mockService expect] executeRequest:
     [SocializeRequest requestWithHttpMethod:@"POST"
                                resourcePath:@"like/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]];

    [_mockService postLikeForEntity:mockEntity andLongitude:nil latitude:nil];
    [_mockService verify];
}

-(void)testpostLikeForEntityWithGeo{
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    NSNumber* lng = [NSNumber numberWithFloat:-122.397850];
    NSNumber* lat = [NSNumber numberWithFloat:37.786521];
    
    NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, ENTITY, lng, @"lng", lat, @"lat", nil];
    NSArray *params = [NSArray arrayWithObjects:entityParam, 
                       nil];
    
    [[_mockService expect] executeRequest:
     [SocializeRequest requestWithHttpMethod:@"POST"
                                resourcePath:@"like/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:params]];

    [_mockService postLikeForEntity:mockEntity andLongitude:lng latitude:lat];
    [_mockService verify];
}

-(void)testGetLikesCallback{
    SocializeRequest *request = [SocializeRequest requestWithHttpMethod:@"GET" resourcePath:@"invalidparam" expectedJSONFormat:SocializeDictionary params:nil];
    request.delegate = self;

    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/like_single_response.json"];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    _service.delegate = [mockDelegate retain];
    
    [[mockDelegate expect] service:_service didFetchElements:OCMOCK_ANY];
    
    [_service request:request didLoadRawResponse:[JSONStringToParse dataUsingEncoding:NSUTF8StringEncoding]];
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
