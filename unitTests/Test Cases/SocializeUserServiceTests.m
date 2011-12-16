//
//  SocializeUserServiceTests.m
//  SocializeSDK
//
//  Created by William M. Johnson on 6/28/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeUserServiceTests.h"
#import "SocializeObjectFactory.h"
#import "SocializePrivateDefinitions.h"
#import "SocializeCommonDefinitions.h"
#import "JSONKit.h"

@implementation SocializeUserServiceTests
// Run before each test method
- (void)setUp 
{ 
    
    mockfactory  = [OCMockObject mockForClass:[SocializeObjectFactory class]];
    mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    
    _userService = [[SocializeUserService alloc] initWithObjectFactory:mockfactory 
                                                             delegate:mockDelegate];
    
    _mockUserService = [[_userService nonRetainingMock] retain];
}

// Run after each test method
- (void)tearDown 
{
    
    [_userService release];
    [_mockUserService release];
}

-(void)testCheckProtocolType
{
    id expectedProtocol = @protocol(SocializeFullUser);
    id actualProtocol = [_userService ProtocolType];
    GHAssertEqualObjects(expectedProtocol, actualProtocol, nil);
}

//Too much repeated code!!!! I am just trying to get this done.  Logic is correct (for right now) but needs to be refactored!!!!

-(void)testGetUserWithID
{
    int userId = 1234;
    NSDictionary * userIdDictionary = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:[NSNumber numberWithInt:userId]] forKey:@"id"];

    [[_mockUserService expect] executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"user/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:userIdDictionary]
     ];

    [_userService getUserWithId:userId];
    
    [_mockUserService verify];
        
}

-(void)testGetCurrentUser
{
    NSString * JSONFilePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",@"JSON-RequestAndResponse-TestFiles", @"responses/user_small_response.json" ] ofType:nil];
    
    
    NSString * JSONString = [NSString stringWithContentsOfFile:JSONFilePath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
    NSDictionary* userDictionary = (NSDictionary *)[JSONString objectFromJSONStringWithParseOptions:JKParseOptionUnicodeNewlines];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userDictionary];
        [userDefaults setObject:data forKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
        [userDefaults synchronize];
    }
    NSNumber* userId = [userDictionary objectForKey:@"id"];
    NSArray* ids = [NSArray arrayWithObject:userId];
    NSDictionary * userIdDictionary = [NSDictionary dictionaryWithObject:ids forKey:@"id"];
    
    [[_mockUserService expect] executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"user/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:userIdDictionary]];

       
    id mockSmallUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    int idOfUser = [userId intValue];
    [[[mockSmallUser stub]andReturnValue:OCMOCK_VALUE(idOfUser)]objectID];
    [[[mockfactory stub]andReturn:mockSmallUser]createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeUser)];
    
    [_userService getCurrentUser];
    
    [userDefaults removeObjectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    [userDefaults synchronize];
    
    [_mockUserService verify];
}

-(void)testUpdateUser
{
    
    NSInteger userId = 20;
    id mockUser = [OCMockObject mockForClass:[SocializeUser class]];

    [[[mockUser expect] andReturnValue:OCMOCK_VALUE(userId)] objectID];

    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"value", @"key",
                                    nil];
    
    [[[mockfactory expect]andReturn:userDictionary] createDictionaryRepresentationOfObject:mockUser];
    
    NSDictionary * requestDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [userDictionary JSONString], @"jsonData", nil];
    
    SocializeRequest *expectedRequest = [SocializeRequest requestWithHttpMethod:@"POST"
                                                                   resourcePath:@"user/20/"
                                                             expectedJSONFormat:SocializeDictionary
                                                                         params:requestDictionary];
    expectedRequest.operationType = SocializeRequestOperationTypeUpdate;
    
    [[[_mockUserService expect] andDo:^(NSInvocation *inv) {
        [self notify:kGHUnitWaitStatusSuccess];
    }] executeRequest:expectedRequest];

    
    [self prepare];
    [_userService updateUser:mockUser];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1];
    
    [mockfactory verify];
    [_mockUserService verify];    
}


@end
