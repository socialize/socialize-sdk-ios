//
//  SocializeShareTests.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeShareTests.h"
#import <OCMock/OCMock.h>
#import "SocializeShare.h"

@interface SocializeShareTests()
-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName;
@end

@implementation SocializeShareTests

-(void) setUpClass
{  
    SocializeObjectFactory* factory = [[SocializeObjectFactory new] autorelease];
    _service = [[SocializeShareService alloc] initWithObjectFactory:factory delegate:self];
    _mockService = [[_service nonRetainingMock] retain];
    _testError = [NSError errorWithDomain:@"Socialize" code: 400 userInfo:nil];
}

-(void) tearDownClass
{
    [_mockService release]; _mockService = nil;
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
    
    SocializeObjectFactory* objectCreator = [[SocializeObjectFactory alloc] init];
    SocializeEntity* mockEntity = [objectCreator createObjectForProtocol:@protocol(SocializeEntity)]; 
    
    mockEntity.key = @"www.123.com";
    
    SocializeShareMedium medium = SocializeShareMediumFacebook;
    
    NSArray *expectedParams = [NSArray arrayWithObject:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                mockEntity.key, @"entity_key",
                                [NSNumber numberWithInt:medium], @"medium",
                                @"text", @"text",
                                nil]];
    
    [[_mockService expect] executeRequest:
     [SocializeRequest requestWithHttpMethod:@"POST"
                                resourcePath:@"share/"
                          expectedJSONFormat:SocializeDictionaryWithListAndErrors
                                      params:expectedParams]];

    [_mockService createShareForEntity:mockEntity  medium:medium  text:@"text"];
    [_mockService verify];
}

-(void)testProtocol
{
    GHAssertTrue([_service ProtocolType] == @protocol(SocializeShare), nil);
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
