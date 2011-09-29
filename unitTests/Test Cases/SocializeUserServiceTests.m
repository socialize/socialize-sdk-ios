//
//  SocializeUserServiceTests.m
//  SocializeSDK
//
//  Created by William M. Johnson on 6/28/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeUserServiceTests.h"
#import "SocializeObjectFactory.h"
#import "SocializeProvider.h"
#import "SocializeCommonDefinitions.h"
#import "JSONKit.h"

@implementation SocializeUserServiceTests

// Run before each test method
- (void)setUp 
{ 
    
    mockfactory  = [OCMockObject mockForClass:[SocializeObjectFactory class]];
    mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    
    _userService = [[SocializeUserService alloc] initWithProvider:mockProvider 
                                                    objectFactory:mockfactory 
                                                             delegate:mockDelegate];
    
}

// Run after each test method
- (void)tearDown 
{
    
    [_userService release];
    
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
    NSDictionary * userIdDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:userId] forKey:@"id"];
    [[mockProvider expect]
     requestWithMethodName:@"user/" andParams:userIdDictionary expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:_userService];

    [_userService userWithId:userId];
    
    [mockProvider verify];
        
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
    NSDictionary * userIdDictionary = [NSDictionary dictionaryWithObject:userId forKey:@"id"];
    [[mockProvider expect]
     requestWithMethodName:@"user/" andParams:userIdDictionary expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:_userService];
       
    id mockSmallUser = [OCMockObject mockForProtocol:@protocol(SocializeUser)];
    int idOfUser = [userId intValue];
    [[[mockSmallUser stub]andReturnValue:OCMOCK_VALUE(idOfUser)]objectID];
    [[[mockfactory stub]andReturn:mockSmallUser]createObjectFromDictionary:OCMOCK_ANY forProtocol:@protocol(SocializeUser)];
    
    [_userService currentUser];
    
    [userDefaults removeObjectForKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    [userDefaults synchronize];
}

-(void)testUpdateUser
{
    
    id mockUser = [OCMockObject mockForClass:[SocializeUser class]];

    
    NSString * requestDataString = @"fooSchnickens";
    
    [[[mockfactory expect]andReturn:requestDataString]createStringRepresentationOfObject:mockUser];
    
    NSDictionary * requestDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        requestDataString, @"jsonData",
   
                                        nil];
    
    [[mockProvider expect]
     requestWithMethodName:@"user/" andParams:requestDictionary expectedJSONFormat:SocializeDictionary andHttpMethod:@"POST" andDelegate:_userService];
    
    
    [_userService updateUser:mockUser];
    
    [mockfactory verify];
    [mockProvider verify];    
}


@end
