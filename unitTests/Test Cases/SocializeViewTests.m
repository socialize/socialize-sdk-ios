//
//  SocializeViewTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeViewTests.h"
#import "SocializeProvider.h"
#import <OCMock/OCMock.h>

@interface SocializeViewTests() 
-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName;
@end

@implementation SocializeViewTests

-(void) setUpClass
{  
    SocializeObjectFactory* factory = [[SocializeObjectFactory new] autorelease];
    _service = [[SocializeViewService alloc] initWithProvider:nil objectFactory:factory delegate:self];
    _testError = [NSError errorWithDomain:@"Socialize" code: 400 userInfo:nil];
}

-(void) tearDownClass
{
    [_service release]; _service = nil;
}

-(void)testpostLikeForEntity{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    
    NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, @"entity", nil];
    NSArray *params = [NSArray arrayWithObjects:entityParam, 
                       nil];
    
    [[mockProvider expect] requestWithMethodName:@"view/" andParams:params andHttpMethod:@"POST" andDelegate:_service];
    
    [_service createViewForEntity:mockEntity];
    [mockProvider verify];
}

-(void)testCreateViewCallback{
    
    SocializeRequest* _request = [SocializeRequest getRequestWithParams:nil httpMethod:@"POST" delegate:self requestURL:@"whatever"];
    
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/view_single_response.json"];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeViewServiceDelegate)];
    _service.delegate = mockDelegate;
    
    [[mockDelegate expect] viewService:_service didReceiveView:OCMOCK_ANY];
    
    [_service request:_request didLoadRawResponse:[JSONStringToParse dataUsingEncoding:NSUTF8StringEncoding]];
    [mockDelegate verify];
}

-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName {
    
    NSString * JSONFilePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",@"JSON-RequestAndResponse-TestFiles", fileName ] ofType:nil];
    
    NSString * JSONString = [NSString stringWithContentsOfFile:JSONFilePath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
    
    return  JSONString;
}

-(void) viewService:(SocializeViewService *)viewService didReceiveView:(id<SocializeView>)viewObject{
    
}

-(void) viewService:(SocializeViewService *)viewService didReceiveListOfViews:(NSArray *)viewList{
    
}

-(void) viewService:(SocializeViewService *)viewService didFailWithError:(NSError *)error{

}
@end
