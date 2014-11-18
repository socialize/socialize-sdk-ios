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
#import <FacebookSDK/FacebookSDK.h>
#import "SocializeCommonDefinitions.h"
#import "SocializePrivateDefinitions.h"
#import <OAuthConsumer/OAuthConsumer.h>
#import "SocializeTestCase.h"
#import "SZIdentifierUtils.h"

@implementation SocializeAuthTests

-(void) setUp
{
    [super setUp];
    _service = [[SocializeAuthenticateService alloc] init];
    _mockService = [[_service nonRetainingMock] retain];
    _testError = [NSError errorWithDomain:@"" code: 402 userInfo:nil];
}

-(void) tearDown
{
    [_partial release]; _partial = nil;
    [_service release]; _service = nil;
    [_mockService release]; _mockService = nil;
    [super tearDown];
}

- (void)becomePartial {
    if (_partial == nil) {
        _partial = [[OCMockObject partialMockForObject:_service] retain];
    }
}

- (void)expectRequest:(void(^)(SocializeRequest *request))verify {
    [self becomePartial];
    [[[_partial expect] andDo1:verify] executeRequest:OCMOCK_ANY];
}

-(void)testAuthParams{
    [[[_mockService expect] andDo1:^(SocializeRequest *request) {
        GHAssertEqualStrings(request.resourcePath, @"authenticate/", @"Bad path");
        GHAssertNotNil(request.params, @"Missing params");

        NSString *adsId = [SZIdentifierUtils base64AdvertisingIdentifierString];
        NSString *vendorId = [SZIdentifierUtils base64VendorIdentifierString];
        
        //these should either both be nil or equal
        NSString *matchAdsId = (NSString *)[request.params objectForKey:IDFAKey];
        NSString *matchVendorId = (NSString *)[request.params objectForKey:IDFVKey];
        
        //nil for headless devices
        if(adsId != nil && matchAdsId != nil) {
            GHAssertEqualStrings(adsId, matchAdsId, @"");
        }
        
        if(vendorId != nil && matchVendorId != nil) {
            GHAssertEqualStrings(vendorId, matchVendorId, @"");
        }
        
    }] executeRequest:OCMOCK_ANY];

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
    [[mockDelegate expect] didAuthenticate:OCMOCK_ANY];

    NSString* reponseString =@"{\"oauth_token_secret\": \"f0e68570-00a4-4516-af27-b61a23099ad4\", \"oauth_token\": \"7ef9831c-5e23-4060-b197-4df5481a381d\", \"user\": {\"username\": \"User3920508\", \"id\": 3920508, \"small_image_uri\": null}}";
    
    NSData *data = [reponseString dataUsingEncoding:NSUTF8StringEncoding];
    [_service request:nil didLoadRawResponse:data];
    [mockDelegate verify];

   // [self waitForStatus:kGHUnitWaitStatusSuccess timeout:30.0];
}

- (void)testThatNilAdvertisingIdentifierStillAuthenticatesWithThirdParty {
    NSString *token = @"token";
    NSString *secret = @"secret";
    SocializeThirdPartyAuthType authType = SocializeThirdPartyAuthTypeFacebook;
    NSString *authTypeString = [NSString stringWithFormat:@"%d", authType];
    
    [self becomePartial];
    
    [SZIdentifierUtils startMockingClass];
    [self atTearDown:^{
        [SZIdentifierUtils stopMockingClassAndVerify];
    }];
    
    [self expectRequest:^(SocializeRequest *request) {
        NSDictionary *params = request.params;
        GHAssertEqualStrings([params objectForKey:@"auth_token"], token, @"Bad token");
        GHAssertEqualStrings([params objectForKey:@"auth_token_secret"], secret, @"Bad secret");
        GHAssertEqualObjects([params objectForKey:@"auth_type"], authTypeString, @"Bad type");
    }];

    [[[SZIdentifierUtils stub] andReturn:nil] base64AdvertisingIdentifierString];

    [_service authenticateWithThirdPartyAuthType:authType thirdPartyAuthToken:token thirdPartyAuthTokenSecret:secret];
}

-(void)didAuthenticate: (id<SocializeUser>)user{
   // [self notify:kGHUnitWaitStatusSuccess];
    return;
}

-(void)service:(SocializeService *)service didFail:(NSError *)error{
    NSLog(@"%@", error);
}


@end
