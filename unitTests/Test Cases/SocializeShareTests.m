//
//  SocializeShareTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareTests.h"
#import "SocializeProvider.h"
#import <OCMock/OCMock.h>

@interface SocializeShareTests()
-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName;
@end

@implementation SocializeShareTests

-(void) setUpClass
{  
    SocializeObjectFactory* factory = [[SocializeObjectFactory new] autorelease];
    _service = [[SocializeShareService alloc] initWithProvider:nil objectFactory:factory delegate:self];
    _testError = [NSError errorWithDomain:@"Socialize" code: 400 userInfo:nil];
}

-(void) tearDownClass
{
    [_service release]; _service = nil;
}


-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName {
    
    NSString * JSONFilePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",@"JSON-RequestAndResponse-TestFiles", fileName ] ofType:nil];
    
    NSString * JSONString = [NSString stringWithContentsOfFile:JSONFilePath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
    
    return  JSONString;
}

-(void)testCreateShareForEntity{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    
    ShareMedium medium = Facebook;
    
    //NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, @"entity", nil];
    //NSArray *params = [NSArray arrayWithObjects:entityParam, 
      //                 nil];
    
    [[mockProvider expect] requestWithMethodName:@"share/" andParams:OCMOCK_ANY andHttpMethod:@"POST" andDelegate:_service];
    
    [_service createShareForEntity:mockEntity  medium:medium  text:@"text"];
    [mockProvider verify];
}

-(void)testCreateViewCallback{
    
    SocializeRequest* _request = [SocializeRequest getRequestWithParams:nil httpMethod:@"POST" delegate:self requestURL:@"whatever"];
    
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/share_single_response.json"];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeShareServiceDelegate)];
    _service.delegate = mockDelegate;
    
    [[mockDelegate expect] shareService:_service didReceiveShare:OCMOCK_ANY];
    
    [_service request:_request didLoadRawResponse:[JSONStringToParse dataUsingEncoding:NSUTF8StringEncoding]];
//    [mockDelegate verify];
}

-(void) shareService:(SocializeShareService *)shareService didReceiveShare:(id<SocializeShare>)viewObject{
    
}

-(void) shareService:(SocializeShareService *)shareService didReceiveListOfShare:(NSArray *)viewList{
    
}

-(void) shareService:(SocializeShareService *)shareService didFailWithError:(NSError *)error{
    
}

@end
