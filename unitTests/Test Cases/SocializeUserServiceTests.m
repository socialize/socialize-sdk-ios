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


//Too much repeated code!!!! I am just trying to get this done.  Logic is correct (for right now) but needs to be refactored!!!!

//-(void)testGetUserWithID
//{
//    
//    
//    NSString* dumbyString = @"BLAHHHHHHH";
//    NSData * dumbyData = [dumbyString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
//    {
//        [_userService request:nil didLoadRawResponse:dumbyData];
//    };
//    
//    
//    int userId = 1234;
//    NSDictionary * userIdDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:userId] forKey:@"id"];
//    [[[mockProvider expect]andDo:testBlock]
//     requestWithMethodName:@"user/" andParams:userIdDictionary expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:_userService];
//    
//    id mockUser2 = [OCMockObject niceMockForClass:[SocializeUser class]];
//    [[[mockfactory expect]andReturn:mockUser2]createObjectFromString:dumbyString forProtocol:@protocol(SocializeUser)];
//    BOOL yes = YES;
//    [[[mockUser2 expect]andReturnValue:OCMOCK_VALUE(yes)]conformsToProtocol:@protocol(SocializeObject)];
//    
/////    [[mockDelegate expect] userService:_userService didReceiveUser:mockUser2];
//    [_userService userWithId:userId];
//    
//    [mockDelegate verify];
//    [mockfactory verify];
//    [mockProvider verify];
//    [mockUser2 verify];
//        
//}

//TODO:: fix it
//-(void)testGetCurrentUser
//{
//    
//    NSString* dumbyString = @"BLAHHHHHHH";
//    NSData * dumbyData = [dumbyString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
//    {
//        [_userService request:nil didLoadRawResponse:dumbyData];
//    };
//    
//    
//    [[[mockProvider expect]andDo:testBlock]
//     requestWithMethodName:@"user/" andParams:nil expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"GET" andDelegate:_userService];
//    
//    id mockUser2 = [OCMockObject niceMockForClass:[SocializeUser class]];
//    [[[mockfactory expect]andReturn:mockUser2]createObjectFromString:dumbyString forProtocol:@protocol(SocializeUser)];
//    
//    BOOL yes = YES;
//    [[[mockUser2 expect]andReturnValue:OCMOCK_VALUE(yes)]conformsToProtocol:@protocol(SocializeObject)];
//    
////    [[mockDelegate expect] userService:_userService didReceiveUser:mockUser2];
//    [_userService currentUser];
//    
//    [mockDelegate verify];
//    [mockfactory verify];
//    [mockProvider verify];
//    [mockUser2 verify];
//    
//}

//DuplicateCode
//-(void)testUpdateUser
//{
//    
//    id mockUser = [OCMockObject mockForClass:[SocializeUser class]];
//
//    
//    NSString * requestDataString = @"fooSchnickens";
//    
//    [[[mockfactory expect]andReturn:requestDataString]createStringRepresentationOfObject:mockUser];
//    
//    NSDictionary * requestDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        requestDataString, @"jsonData",
//   
//                                        nil];
//    
//    NSString* dumbyString = @"BLAHHHHHHH";
//    NSData * dumbyData = [dumbyString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    id mockUser2 = [OCMockObject niceMockForClass:[SocializeUser class]];
//    [[[mockfactory expect]andReturn:mockUser2]createObjectFromString:dumbyString forProtocol:@protocol(SocializeUser)];
//    
//    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
//    {
//        [_userService request:nil didLoadRawResponse:dumbyData];
//    };
//    
//    
//    [[[mockProvider expect]andDo:testBlock]
//     requestWithMethodName:@"user/" andParams:requestDictionary expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_userService];
//    
//    BOOL yes = YES;
//    [[[mockUser2 expect]andReturnValue:OCMOCK_VALUE(yes)]conformsToProtocol:@protocol(SocializeObject)];
//    
//    [[mockDelegate expect] service:_userService didUpdate:OCMOCK_ANY];
//    [_userService updateUser:mockUser];
//    
//    [mockDelegate verify];
//    [mockfactory verify];
//    [mockProvider verify];
//    [mockUser verify];
//    [mockUser2 verify];
//    
//    
//}

//TODO:: fix it
//-(void)testFailUserServiceParseUserObjectResponse
//{
//    
//    id mockUser = [OCMockObject mockForClass:[SocializeUser class]];
//    
//    SocializeRequest*    request = [SocializeRequest getRequestWithParams:nil
//                                                        expectedJSONFormat:SocializeDictionary
//                                                                httpMethod:@"POST"
//                                                                  delegate:nil
//                                                                requestURL:nil];
//
//    NSString * requestDataString = @"fooSchnickens";
//    
//    [[[mockfactory expect]andReturn:requestDataString]createStringRepresentationOfObject:mockUser];
//    
//    NSDictionary * requestDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        requestDataString, @"jsonData",
//                                        
//                                        nil];
//    
//    NSString* dumbyString = @"BLAHHHHHHH";
//    NSData * dumbyData = [dumbyString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSObject * badObject = [[NSObject new]autorelease];
//    [[[mockfactory expect]andReturn:badObject]createObjectFromString:dumbyString forProtocol:@protocol(SocializeUser)];
//    
//    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
//    {
//        [_userService request:request didLoadRawResponse:dumbyData];
//    };
//    
//    
//    [[[mockProvider expect]andDo:testBlock]
//     requestWithMethodName:@"user/" andParams:requestDictionary expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_userService];
//    
//    [[mockDelegate expect] service:_userService didFail:OCMOCK_ANY];
//    [_userService updateUser:mockUser];
//    
//    [mockDelegate verify];
//    [mockfactory verify];
//    [mockProvider verify];
//    [mockUser verify];
//}

//TODO:: fix it
//
//-(void)testFailUserServiceRequest
//{
//    
//    id mockUser = [OCMockObject mockForClass:[SocializeUser class]];
//    
//    
//    NSString * requestDataString = @"fooSchnickens";
//    
//    [[[mockfactory expect]andReturn:requestDataString]createStringRepresentationOfObject:mockUser];
//    
//    NSDictionary * requestDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        requestDataString, @"jsonData",
//                                        
//                                        nil];
//    
//    NSError * mockError = [[NSError new] autorelease];
//    void (^testBlock)(NSInvocation *) = ^(NSInvocation *invocation) 
//    {
//        [_userService request:nil didFailWithError:mockError];
//    };
//    
//    
//    [[[mockProvider expect]andDo:testBlock]
//     requestWithMethodName:@"user/" andParams:requestDictionary expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_userService];
//    
//    [[mockDelegate expect] service:_userService didFail:OCMOCK_ANY];
//    [_userService updateUser:mockUser];
//    
//    [mockDelegate verify];
//    [mockfactory verify];
//    [mockProvider verify];
//    [mockUser verify];
//}
//




@end
