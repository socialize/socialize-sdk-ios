//
//  SocializeTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/21/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeTests.h"
#import <OCMock/OCMock.h>
#import "SocializeAuthenticateService.h"
#import "SocializeLikeService.h"
#import "SocializeEntityService.h"
#import "SocializeActivityService.h"
#import "SocializeCommentsService.h"
#import "SocializeUserService.h"
#import "SocializeViewService.h"
#import "SocializeSubscriptionService.h"
#import "SocializeDeviceTokenService.h"

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

-(void)testRemoveAuthInfo {
    id mockService = [OCMockObject mockForClass:[SocializeAuthenticateService class]];
    _service.authService = mockService;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    
    [[mockService expect] removeSocializeAuthenticationInfo];
    
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

-(void)testSaveSoializeInfo
{
    NSString* apiKey = @"0000000-1111101110-1111";
    NSString* apiSecret = @"11111111-222222-333333";
    
    [Socialize storeConsumerKey:apiKey];
    [Socialize storeConsumerSecret:apiSecret];
    
    GHAssertEqualStrings(apiKey,[Socialize apiKey], nil);
    GHAssertEqualStrings(apiSecret,[Socialize apiSecret], nil);
    
}


- (void)testAuthenticateWithFacebook {
    id mockAuthService = [OCMockObject mockForClass:[SocializeAuthenticateService class]];
    Socialize *socialize = [[Socialize alloc] initWithDelegate:nil];
    socialize.authService = mockAuthService;

    [[NSUserDefaults standardUserDefaults] setObject:@"1234" forKey:@"FBAccessTokenKey"];
    [[mockAuthService expect] linkToFacebookWithAccessToken:@"1234"];
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    [socialize authenticateWithFacebook];
#pragma GCC diagnostic pop

    [mockAuthService verify];
    [socialize release];
}


- (void)testSetDelegate {
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    Socialize *socialize = [[Socialize alloc] initWithDelegate:nil];
    id auth = socialize.authService = [OCMockObject mockForClass:[SocializeAuthenticateService class]];
    id like = socialize.likeService = [OCMockObject mockForClass:[SocializeLikeService class]];
    id entity = socialize.entityService = [OCMockObject mockForClass:[SocializeEntityService class]];
    id activity = socialize.activityService = [OCMockObject mockForClass:[SocializeActivityService class]];
    id comments = socialize.commentsService = [OCMockObject mockForClass:[SocializeCommentsService class]];
    id user = socialize.userService = [OCMockObject mockForClass:[SocializeUserService class]];
    id view = socialize.viewService = [OCMockObject mockForClass:[SocializeViewService class]];
    
    [[auth expect] setDelegate:mockDelegate];    
    [[like expect] setDelegate:mockDelegate];    
    [[entity expect] setDelegate:mockDelegate];    
    [[activity expect] setDelegate:mockDelegate];    
    [[comments expect] setDelegate:mockDelegate];    
    [[user expect] setDelegate:mockDelegate];    
    [[view expect] setDelegate:mockDelegate];    
    [socialize setDelegate:mockDelegate];
    
    [auth verify]; [like verify]; [entity verify]; [activity verify]; [comments verify]; [user verify]; [view verify];
}

- (void)testWrappedFunctions {
    Socialize *socialize = [[Socialize alloc] initWithDelegate:nil];
    id like = socialize.likeService = [OCMockObject mockForClass:[SocializeLikeService class]];
    id comments = socialize.commentsService = [OCMockObject mockForClass:[SocializeCommentsService class]];
    id entity = socialize.entityService = [OCMockObject mockForClass:[SocializeEntityService class]];
    id user = socialize.userService = [OCMockObject mockForClass:[SocializeUserService class]];
    id activity = socialize.activityService = [OCMockObject mockForClass:[SocializeActivityService class]];
    id view = socialize.viewService = [OCMockObject mockForClass:[SocializeViewService class]];
    id subscription = socialize.subscriptionService = [OCMockObject mockForClass:[SocializeSubscriptionService class]];

    id<SocializeLike> likeEntity = [socialize createObjectForProtocol:@protocol(SocializeLike)];
    [[like expect] deleteLike:likeEntity];
    [socialize unlikeEntity:likeEntity];
    [like verify];
    
    [[like expect] getLikesForEntityKey:@"key" first:[NSNumber numberWithInt:1] last:[NSNumber numberWithInt:2]];
    [socialize getLikesForEntityKey:@"key" first:[NSNumber numberWithInt:1] last:[NSNumber numberWithInt:2]];
    [like verify];
    
    [[like expect] postLikeForEntityKey:@"key" andLongitude:nil latitude:nil];
    [socialize likeEntityWithKey:@"key" longitude:nil latitude:nil];
    [like verify];

    [[comments expect] getCommentById:1];
    [socialize getCommentById:1];
    [comments verify];
    
    [[comments expect] getCommentList:@"key" first:nil last:nil];
    [socialize getCommentList:@"key" first:nil last:nil];
    [comments verify];
    
    [[comments expect] createCommentForEntity:nil comment:nil longitude:nil latitude:nil];
    [socialize createCommentForEntity:nil comment:nil longitude:nil latitude:nil];
    [comments verify];
    
    [[comments expect] createCommentForEntityWithKey:nil comment:nil longitude:nil latitude:nil];
    [socialize createCommentForEntityWithKey:nil comment:nil longitude:nil latitude:nil];
    [comments verify];
    
    [[entity expect] createEntityWithKey:@"url" andName:@"name"];
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    [socialize createEntityWithUrl:@"url" andName:@"name"];
#pragma GCC diagnostic pop

    [entity verify];

    [[entity expect] entityWithKey:@"key"];
    [socialize getEntityByKey:@"key"];
    [entity verify];
    
    [[user expect] getCurrentUser];
    [socialize getCurrentUser];
    [user verify];
    
    [[user expect] getUserWithId:1];
    [socialize getUserWithId:1];
    [user verify];
    
    id<SocializeFullUser> u1 = [[[SocializeFullUser alloc] init] autorelease];
    UIImage *mockImage = [OCMockObject mockForClass:[UIImage class]];
    [[user expect] updateUser:u1 profileImage:mockImage];
    [socialize updateUserProfile:u1 profileImage:mockImage];
    [user verify];
    
    [[user expect] updateUser:u1];
    [socialize updateUserProfile:u1];
    [user verify];

    [[activity expect] getActivityOfCurrentApplication];
    [socialize getActivityOfCurrentApplication];
    [activity verify];
    
    id<SocializeUser> usmall = [socialize createObjectForProtocol:@protocol(SocializeUser)];
    [[activity expect] getActivityOfUser:usmall];
    [socialize getActivityOfUser:usmall];
    [activity verify];
    

    id<SocializeEntity> viewedEntity = [socialize createObjectForProtocol:@protocol(SocializeEntity)];
    [[view expect] createViewForEntity:viewedEntity longitude:nil latitude:nil];
    [socialize viewEntity:viewedEntity longitude:nil latitude:nil];
    [view verify];
    
    // Subscribe to comments
    NSString *testSubscriptionKey = @"testSubscriptionKey";
    [[subscription expect] subscribeToCommentsForEntityKey:testSubscriptionKey];
    [socialize subscribeToCommentsForEntityKey:testSubscriptionKey];
    
    // Unsubscribe from comments
    [[subscription expect] unsubscribeFromCommentsForEntityKey:testSubscriptionKey];
    [socialize unsubscribeFromCommentsForEntityKey:testSubscriptionKey];

    // Get subscriptions
    id mockSubscriptionStart = [OCMockObject mockForClass:[NSNumber class]];
    id mockSubscriptionEnd = [OCMockObject mockForClass:[NSNumber class]];
    [[subscription expect] getSubscriptionsForEntityKey:testSubscriptionKey first:mockSubscriptionStart last:mockSubscriptionEnd];
    [socialize getSubscriptionsForEntityKey:testSubscriptionKey first:mockSubscriptionStart last:mockSubscriptionEnd];
}

- (void)testAuthWrappers {
    Socialize *socialize = [[Socialize alloc] initWithDelegate:nil];
    id auth = socialize.authService = [OCMockObject mockForClass:[SocializeAuthenticateService class]];

    NSString* apiKey = @"0000000-1111101110-1111";
    NSString* apiSecret = @"11111111-222222-333333";
    [Socialize storeConsumerKey:apiKey];
    [Socialize storeConsumerSecret:apiSecret];
    
    [[auth expect] authenticateWithApiKey:apiKey apiSecret:apiSecret];
    [socialize authenticateAnonymously];
    [auth verify];
    
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
