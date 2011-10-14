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
#import "SocializeFBConnect.h"
#import "SocializeCommonDefinitions.h"
#import "SocializePrivateDefinitions.h"
#import "OAuthConsumer.h"


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
    
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   [NSString stringWithFormat:@"{\"udid\":\"%@\"}", [UIDevice currentDevice].uniqueIdentifier],@"jsonData",
//                                   nil];
//    
//    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
//    [[mockProvider expect] secureRequestWithMethodName:@"authenticate/" andParams:params expectedJSONFormat:SocializeDictionary andHttpMethod:@"POST" andDelegate:_service];
//        
//    _service.provider = mockProvider;
//
//    [_service authenticateWithApiKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" apiSecret:@"b7364905-cdc6-46d3-85ad-06516b128819"];
//    [mockProvider verify];
}

-(void)testAuthAnonymousParams{
    
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIDevice currentDevice].uniqueIdentifier,@"udid",
//                                       @"1"/* auth type is for facebook*/ , @"auth_type",
//                                       @"another token", @"auth_token",
//                                       @"anotheruserid", @"auth_id" , nil] ;
//    
//    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
//    
//    [[mockProvider expect] secureRequestWithMethodName:@"authenticate/" andParams:params expectedJSONFormat:SocializeDictionary andHttpMethod:@"POST" andDelegate:_service];
//    _service.provider = mockProvider;
//        
//    [_service  authenticateWithApiKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" 
//            apiSecret:@"b7364905-cdc6-46d3-85ad-06516b128819" 
//            thirdPartyAuthToken:@"another token"
//            thirdPartyAppId:@"anotheruserid"
//                        thirdPartyName:FacebookAuth];
//    
//    
//    [mockProvider verify];
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
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    _service.delegate = [mockDelegate retain];
    [[mockDelegate expect] didAuthenticate:nil];

    NSString* reponseString =@"{\"oauth_token_secret\": \"f0e68570-00a4-4516-af27-b61a23099ad4\", \"oauth_token\": \"7ef9831c-5e23-4060-b197-4df5481a381d\", \"user\": {\"username\": \"User3920508\", \"id\": 3920508, \"small_image_uri\": null}}";
    
    NSData *data = [reponseString dataUsingEncoding:NSUTF8StringEncoding];
    [_service request:nil didLoadRawResponse:data];
    [mockDelegate verify];

   // [self waitForStatus:kGHUnitWaitStatusSuccess timeout:30.0];
}

-(void)didAuthenticate: (id<SocializeUser>)user{
   // [self notify:kGHUnitWaitStatusSuccess];
    return;
}

-(void)service:(SocializeService *)service didFail:(NSError *)error{
    NSLog(@"%@", error);
}


-(void) testPerformFacebookAuthenticationFirstTime
{
    NSString* apiKey = @"apiKey";
    NSString* apiSecret = @"apiSecret";
    NSString* appId = @"appId";
    
    id fbMock = [OCMockObject mockForClass: [SocializeFacebook class]];
    BOOL key = NO; 
    [[[fbMock stub]andReturnValue:OCMOCK_VALUE(key)]isSessionValid];
    
    FacebookAuthenticator* fbAuth = [[[FacebookAuthenticator alloc] initWithFramework:fbMock apiKey:apiKey apiSecret:apiSecret appId:appId service:nil]autorelease];
    
    [[fbMock expect]authorize: nil delegate:fbAuth localAppId:nil];
    [fbAuth performAuthentication];
    
    [fbMock verify];
}

-(void) testPerformFacebookAuthenticationSecondTimeWithValidSessionInfo
{
    NSString* apiKey = @"apiKey";
    NSString* apiSecret = @"apiSecret";
    NSString* appId = @"appId";
    NSString* token = @"Token";
    NSDate* date =[NSDate date];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"FBAccessTokenKey"];
    [defaults setObject:date forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    id fbMock = [OCMockObject mockForClass: [SocializeFacebook class]];
    BOOL key = YES; 
    [[[fbMock stub]andReturnValue:OCMOCK_VALUE(key)]isSessionValid];
    [[[fbMock stub]andReturn:token]accessToken];
    [[fbMock expect] setAccessToken: token];
    [[fbMock expect] setExpirationDate: date];
    
    
    id serviceMock = [OCMockObject mockForClass: [SocializeAuthenticateService class]];
    [[serviceMock expect]  authenticateWithApiKey:apiKey apiSecret:apiSecret thirdPartyAuthToken:token thirdPartyAppId:appId thirdPartyName:FacebookAuth];
    
    FacebookAuthenticator* fbAuth = [[[FacebookAuthenticator alloc] initWithFramework:fbMock apiKey:apiKey apiSecret:apiSecret appId:appId service:serviceMock]autorelease];
    
    [fbAuth performAuthentication];
    
    [fbMock verify];
    [serviceMock verify];
    
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void) testHandleURL
{
    id mockFb = [OCMockObject mockForClass: [SocializeFacebook class]];
    [[mockFb expect] handleOpenURL:nil];
    FacebookAuthenticator* fbAuth = [[[FacebookAuthenticator alloc] initWithFramework:mockFb apiKey:@"" apiSecret:@"" appId:@"" service:nil]autorelease];
    [fbAuth handleOpenURL:nil];
    
    [mockFb verify];
}

-(void) testDidFbLogin
{
    NSString* apiKey = @"apiKey";
    NSString* apiSecret = @"apiSecret";
    NSString* appId = @"appId";
    NSString* token = @"Token";
    NSDate* date =[NSDate date];
    
    
    id fbMock = [OCMockObject mockForClass: [SocializeFacebook class]];
    [[[fbMock stub]andReturn:token]accessToken];
    [[[fbMock stub]andReturn:date]expirationDate];
    
    
    id serviceMock = [OCMockObject mockForClass: [SocializeAuthenticateService class]];
    [[serviceMock expect]  authenticateWithApiKey:apiKey apiSecret:apiSecret thirdPartyAuthToken:token thirdPartyAppId:appId thirdPartyName:FacebookAuth];
    
    FacebookAuthenticator* fbAuth = [[[FacebookAuthenticator alloc] initWithFramework:fbMock apiKey:apiKey apiSecret:apiSecret appId:appId service:serviceMock]autorelease];
    
    [fbAuth fbDidLogin];
    
    [fbMock verify];
    [serviceMock verify];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void) testDidFbLogout
{
    FacebookAuthenticator* fbAuth = [[[FacebookAuthenticator alloc] initWithFramework:nil apiKey:@"" apiSecret:@"" appId:@"" service:nil]autorelease];
    
    [fbAuth fbDidLogout];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GHAssertFalse(([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]), nil);
 
}

-(void) testfbDidNotLogin
{
    id serviceMock = [OCMockObject mockForClass: [SocializeAuthenticateService class]];
    [[serviceMock expect] request:nil didFailWithError:OCMOCK_ANY];

    FacebookAuthenticator* fbAuth = [[[FacebookAuthenticator alloc] initWithFramework:nil apiKey:@"" apiSecret:@"" appId:@"" service:serviceMock]autorelease];
    
    [fbAuth fbDidNotLogin: YES];
    
    [serviceMock verify];
}

@end
