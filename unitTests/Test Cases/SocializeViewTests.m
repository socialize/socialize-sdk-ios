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

-(void)testcreateViewForEntity{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    _service.delegate = nil;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    
    NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, @"entity_key", nil];
    NSArray *params = [NSArray arrayWithObjects:entityParam, 
                       nil];
    
    [[mockProvider expect] requestWithMethodName:@"view/" andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_service];
    
    [_service createViewForEntity:mockEntity longitude:nil latitude: nil];
    [mockProvider verify];
}

-(void)testcreateViewForEntityWithGeo{
    
    id mockProvider = [OCMockObject mockForClass:[SocializeProvider class]];
    _service.provider = mockProvider;
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    
    NSDictionary* entityParam = [NSDictionary dictionaryWithObjectsAndKeys:mockEntity.key, @"entity_key", [NSNumber numberWithFloat: 1.2], @"lng", [NSNumber numberWithFloat: 1.2], @"lat", nil];
    NSArray *params = [NSArray arrayWithObjects:entityParam, 
                       nil];
    
    [[mockProvider expect] requestWithMethodName:@"view/" andParams:params expectedJSONFormat:SocializeDictionaryWIthListAndErrors andHttpMethod:@"POST" andDelegate:_service];
    
    [_service createViewForEntity:mockEntity longitude:[NSNumber numberWithFloat: 1.2] latitude: [NSNumber numberWithFloat: 1.2]];
    [mockProvider verify];
}

-(void)testCreateViewCallback{
    
    SocializeRequest* _request = [SocializeRequest getRequestWithParams:nil expectedJSONFormat:SocializeDictionary httpMethod:@"POST"  delegate:self requestURL:@"whatever"];
    
    NSString * JSONStringToParse = [self helperGetJSONStringFromFile:@"responses/view_single_response.json"];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(SocializeServiceDelegate)];
    _service.delegate = [mockDelegate retain];
    
    [[mockDelegate expect] service:_service didCreate:OCMOCK_ANY];
    
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


-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    NSLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    NSLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFetch:(id<SocializeObject>)object{
    NSLog(@"didFetch %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"didFail %@", error);
}

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)objectCreated{
    NSLog(@"didCreateWithElements %@", objectCreated);
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    NSLog(@"didFetchElements %@", dataArray);
}
@end
