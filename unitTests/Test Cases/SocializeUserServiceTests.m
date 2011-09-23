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
    id expectedProtocol = @protocol(SocializeUser);
    id actualProtocol = [_userService ProtocolType];
    GHAssertEqualObjects(expectedProtocol, actualProtocol, nil);
}

//Too much repeated code!!!! I am just trying to get this done.  Logic is correct (for right now) but needs to be refactored!!!!

-(void)testGetUserWithID
{
    int userId = 1234;
    NSDictionary * userIdDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:userId] forKey:@"id"];
    [[mockProvider expect]
     requestWithMethodName:@"user/" andParams:userIdDictionary expectedJSONFormat:SocializeDictionary andHttpMethod:@"GET" andDelegate:_userService];

    [_userService userWithId:userId];
    
    [mockProvider verify];
        
}

-(void)testGetCurrentUser
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    int userId = 1234;
    [def setObject: [NSNumber numberWithInt:userId] forKey:kSOCIALIZE_USERID_KEY];
    [def synchronize];


    NSDictionary * userIdDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:userId] forKey:@"id"];
    [[mockProvider expect]
     requestWithMethodName:@"user/" andParams:userIdDictionary expectedJSONFormat:SocializeDictionary andHttpMethod:@"GET" andDelegate:_userService];
    
    [_userService currentUser];
    
    [def removeObjectForKey:kSOCIALIZE_USERID_KEY];
    [def synchronize];
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
