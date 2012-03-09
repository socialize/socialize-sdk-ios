//
//  SocializeAuthTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/17/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeAuthTests.h"
#import "SocializeAuthenticateService.h"
#import <OCMock/OCMock.h>
#import "Socialize.h"
#import "SocializeFBConnect.h"
#import "SocializeCommonDefinitions.h"
#import "SocializePrivateDefinitions.h"
#import "OAuthConsumer.h"
#import "UIDevice+IdentifierAddition.h"


@implementation SocializeAuthTests

-(void) setUpClass
{
    [super setUpClass];
    _service = [[SocializeAuthenticateService alloc] init];
    _mockService = [[_service nonRetainingMock] retain];
    _testError = [NSError errorWithDomain:@"" code: 402 userInfo:nil];
}

-(void) tearDownClass
{
    //[_service release]; 
    _service = nil;
    [_mockService release]; _mockService = nil;
    [super tearDownClass];
}

-(void)testAuthParams{   
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"{\"udid\":\"%@\"}", [UIDevice currentDevice].uniqueGlobalDeviceIdentifier], @"jsonData",
                                   nil];
    
    [[_mockService expect] executeRequest:
     [SocializeRequest secureRequestWithHttpMethod:@"POST"
                                      resourcePath:@"authenticate/"
                                expectedJSONFormat:SocializeDictionary
                                            params:params]];
    
    [_mockService authenticateWithApiKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" apiSecret:@"b7364905-cdc6-46d3-85ad-06516b128819"];
    [_mockService verify];
}

- (void)testAssociateWithThirdParty {
    NSString *testToken = @"testToken";
    NSString *testTokenSecret = @"testTokenSecret";
    
    [[_mockService expect] executeRequest:OCMOCK_ANY];

    [_mockService associateWithThirdPartyAuthType:SocializeThirdPartyAuthTypeTwitter token:testToken tokenSecret:testTokenSecret];
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


@end
