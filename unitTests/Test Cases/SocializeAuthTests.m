//
//  SocializeAuthTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/17/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeAuthTests.h"
#import "SocializeAuthenticateService.h"
#import "SocializeProvider.h"
#import <OCMock/OCMock.h>
#import "Socialize.h"
#import "SocializeCommonDefinitions.h"


@implementation SocializeAuthTests

-(void) setUpClass
{
    [super setUpClass];
    _service = [[SocializeAuthenticateService alloc] init];
    _testError = [NSError errorWithDomain:@"" code: 402 userInfo:nil];
}

-(void) tearDownClass
{
    //[_service release]; 
    _service = nil;
    [super tearDownClass];
}

-(void)testAuthParams{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"{\"udid\":\"someid\"}",@"jsonData",
                                   nil];
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:@"authenticate/" andParams:params expectedJSONFormat:SocializeDictionary andHttpMethod:@"POST" andDelegate:_service];
    _service.provider = mockProvider;

    [_service authenticateWithApiKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" apiSecret:@"b7364905-cdc6-46d3-85ad-06516b128819" udid:@"someid" ];
    [mockProvider verify];
}

-(NSString*)getSocializeId{
    NSUserDefaults* userPreferences = [NSUserDefaults standardUserDefaults];
    NSString* userJSONObject = [userPreferences valueForKey:kSOCIALIZE_USERID_KEY];
    if (!userJSONObject)
        return @"";
    return userJSONObject;
}

-(void)testAuthAnonymousParams{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"someid",@"udid",
                                       [self getSocializeId] ,  @"socialize_id", 
                                       @"1"/* auth type is for facebook*/ , @"auth_type",
                                       @"another token", @"auth_token",
                                       @"anotheruserid", @"auth_id" , nil] ;
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    
    [[mockProvider expect] requestWithMethodName:@"authenticate/" andParams:params expectedJSONFormat:SocializeDictionary andHttpMethod:@"POST" andDelegate:_service];
    _service.provider = mockProvider;
    
    //[_service authenticateWithApiKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" apiSecret:@"b7364905-cdc6-46d3-85ad-06516b128819" udid:@"someid" //delegate:self];
    
     [_service  authenticateWithApiKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" 
            apiSecret:@"b7364905-cdc6-46d3-85ad-06516b128819" 
            udid:@"someid"
            thirdPartyAuthToken:@"another token"
            thirdPartyUserId:@"anotheruserid"
                        thirdPartyName:FacebookAuth];
    
    
    [mockProvider verify];
}

-(void)testOAtoken{

    OAToken *authToken = [[[OAToken alloc ] initWithKey:@"somekkey" secret:@"somesecret"] autorelease];
    [authToken storeInUserDefaultsWithServiceProviderName:kPROVIDER_NAME prefix:kPROVIDER_PREFIX];
    
    Socialize* socializeObject = [[Socialize alloc] init]; 
    BOOL isTrue = [socializeObject isAuthenticated];
    GHAssertTrue(isTrue  == YES,@"should be authenticated");
}

-(void)testIsAuthenticated{

    [self prepare];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeAuthenticationDelegate)];
    _service.delegate = mockDelegate;
    [[mockDelegate expect] didAuthenticate];

    NSString* reponseString =@"{\"oauth_token_secret\": \"f0e68570-00a4-4516-af27-b61a23099ad4\", \"oauth_token\": \"7ef9831c-5e23-4060-b197-4df5481a381d\", \"user\": {\"username\": \"User3920508\", \"id\": 3920508, \"small_image_uri\": null}}";
    
    NSData *data = [reponseString dataUsingEncoding:NSUTF8StringEncoding];
    [_service request:nil didLoadRawResponse:data];
    [mockDelegate verify];

   // [self waitForStatus:kGHUnitWaitStatusSuccess timeout:30.0];
}

-(void)didAuthenticate{
   // [self notify:kGHUnitWaitStatusSuccess];
    return;
}

-(void)didNotAuthenticate:(NSError*)error{
    NSLog(@"%@", error);
}


@end
