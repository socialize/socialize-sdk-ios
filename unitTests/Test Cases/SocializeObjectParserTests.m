//
//  SocializeObjectParserTests.m
//  SocializeSDK
//
//  Created by William Johnson on 5/23/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//
#import <OCMock/OCMock.h>
#import "JSONKit.h"
#import "SocializeObjectParserTests.h"
#import "Socialize.h"
#import "SocializePOOCObjectFactory.h"


@implementation SocializeObjectParserTests

- (void)setUpClass 
{
    _factory =[[SocializePOOCObjectFactory alloc]init];

}


- (void)tearDownClass 
{
    [_factory release];   
}


-(void)testToEntity
{
   // id mockEntity = [OCMockObject mockForProtocol:@protocol(SocializeEntity)];
  
//    id JSON
//    
    //  id mockFactory = [OCMockObject mockForClass:[SocializePOOCObjectFactory class]];
    
//    
//    [[mockEntity expect]setKey:[OCMArg any]];
//    [[mockEntity expect]setName:[OCMArg any]];
//    [[mockEntity expect]setViews:(int)[OCMArg any]];
//    [[mockEntity expect]setLikes:(int)[OCMArg any]];
//    [[mockEntity expect]setComments:(int)[OCMArg any]];
//    [[mockEntity expect]setShares:(int)[OCMArg any]];

    
    
//    [mockEntity verify];
//    
    
    //Mock Entity
    //Mock JSON 
    //
}

-(void)testFromEntity
{
    
}

-(void)testToUser
{
    
    //Mock Entity
    //Mock JSON 
    //
}

-(void)testFromUser
{
    
    //Mock Entity
    //Mock JSON 
    //
}

@end
