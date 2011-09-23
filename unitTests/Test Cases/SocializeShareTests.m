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
    
    [[mockProvider expect] requestWithMethodName:@"share/" andParams:OCMOCK_ANY expectedJSONFormat:SocializeDictionaryWIthListAndErrors  andHttpMethod:@"POST" andDelegate:_service];
    
    [_service createShareForEntity:mockEntity  medium:medium  text:@"text"];
    [mockProvider verify];
}

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    NSLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    NSLog(@"didUpdate %@", object);
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
