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

-(void)testAuthTests{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"someid", @"udid",
                                   nil];
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    [[mockProvider expect] requestWithMethodName:@"authenticate/" andParams:params andHttpMethod:@"POST" andDelegate:_service];
    _service.provider = mockProvider;

    [_service authenticateWithApiKey:@"98e76bb9-c707-45a4-acf2-029cca3bf216" apiSecret:@"b7364905-cdc6-46d3-85ad-06516b128819" udid:@"someid" delegate:self];
    [mockProvider verify];
}

-(void)didAuthenticate{
    return;
}

-(void)didNotAuthenticate:(NSError*)error{
    NSLog(@"%@", error);
}


@end
