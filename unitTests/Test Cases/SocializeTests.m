//
//  SocializeTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/21/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeTests.h"
#import <OCMock/OCMock.h>


@implementation SocializeTests

-(void) setUpClass
{  
//    SocializeObjectFactory* factory = [[SocializeObjectFactory new] autorelease];
    _service = [[Socialize alloc] initWithDelegate:self];
    _testError = [NSError errorWithDomain:@"Socialize" code: 400 userInfo:nil];
}

-(void) tearDownClass
{
    [_service release]; _service = nil;
}


-(void) testAuthentcation
{
    id mockService = [OCMockObject niceMockForClass:[SocializeAuthenticateService class]];
    _service.authService = mockService;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    NSString* apiKey = @"apikey";
    NSString* apiSecret = @"apisecret";
    
    [[mockService expect] authenticateWithApiKey:apiKey apiSecret:apiSecret];
    
    [_service authenticateWithApiKey:apiKey apiSecret:apiSecret];
    [mockService verify];
}

/*-(void) testisAuthenticated
{
    id mockService = [OCMockObject mockForClass:[SocializeAuthenticateService class]];
    _service.authService = mockService;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    
    [[mockService expect] isAuthenticated];
    
    [_service isAuthenticated];
    [mockService verify];
}
 */

-(void)testRemoveAuthInfo{
    id mockService = [OCMockObject mockForClass:[SocializeAuthenticateService class]];
    _service.authService = mockService;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    
    [[mockService expect] removeAuthenticationInfo];
    
    [_service removeAuthenticationInfo];
    [mockService verify];

}

-(void)testLikeEntity{
    id mockService = [OCMockObject mockForClass:[SocializeLikeService class]];
    _service.likeService = mockService;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    NSNumber* lat = [NSNumber numberWithFloat:37.7];
    NSNumber* lng = [NSNumber numberWithFloat:122.7];
    
    [[mockService expect] postLikeForEntityKey:mockEntity.key andLongitude:lng latitude:lat];
    
    [_service likeEntityWithKey:mockEntity.key longitude:lng latitude:lat];
    [mockService verify];
}


-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    NSLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    NSLog(@"didUpdate %@", object);
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
