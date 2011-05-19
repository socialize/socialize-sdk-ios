//
//  SocializeObjectTests.m
//  SocializeSDK
//
//  Created by William Johnson on 5/16/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//
#import <OCMock/OCMock.h>
#import "SocializeComment.h"
#import "SocializeObjectFactoryTests.h"
#import "SocializeObject.h"
#import "SocializePOOCObjectFactory.h"
#import "SocializeConfiguration.h"

@interface SocializeObjectTests ()

@end

@implementation SocializeObjectTests


- (void)setUpClass 
{
    factory = [[SocializePOOCObjectFactory alloc]init]; 
    configuration = [[SocializeConfiguration alloc] init];
}


- (void)tearDownClass 
{
    [factory release];
    [configuration release];
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

//-(void)testAddProtocolsThatAreNOTSupportted
//{
//    
//    GHAssertThrows([factory  addPrototype:[NSURL class] forKey:@"NSURL"],
//                   @"Factory did not throw exception when adding a unsupported prototype");
//}

-(void)testAddPrototypesToFactoriesThatAreNotSocializeObjects
{
    id mockObject = [OCMockObject mockForClass:[NSObject class]];
    
    [[mockObject expect] conformsToProtocol:[OCMArg any]];
    
    GHAssertThrows([factory  addPrototype:mockObject forKey:@"SocializeComment"],
                   @"Factory did not throw exception when adding a non socialize object");
    
    
    id mockConfiguration = [OCMockObject mockForClass:[SocializeConfiguration class]];
    
    NSDictionary * prototypeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"NSBundle",@"SocializeComment", nil];
    
    NSDictionary * configurationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:prototypeDictionary, kSocializeModuleConfigurationPrototypesKey, nil];
   
    [[[mockConfiguration stub] andReturn:configurationDictionary] configurationInfo];
   
    
    SocializePOOCObjectFactory * myTestFactory = nil;
    
    GHAssertThrows(myTestFactory = [[SocializePOOCObjectFactory alloc]initializeWithConfiguration:mockConfiguration],
               @"Should throw exception");

}

-(void)testCreateCorrectObjectsThatDoExistInFactory
{

    NSString * prototypeClassName = nil;
   
    //Attempt to retrieve the correct object of the correct class for the key
    NSDictionary * protypeDictionary = [configuration.configurationInfo objectForKey:kSocializeModuleConfigurationPrototypesKey];
    
    for (NSString * prototypeName in [protypeDictionary allKeys]) 
    {
        prototypeClassName = (NSString *)[protypeDictionary objectForKey:prototypeName]; 
    
        
        Class expectedClass = NSClassFromString(prototypeClassName);
        
        id actualObject = [factory createObject:prototypeName];
        
        Class actualClass = [actualObject class];
        
        GHAssertTrue(actualClass == expectedClass,
                     @"Actual ->%@ : Expected -> %@ -- wrong class returned from [factory createObject:prototypeKey].",
                     actualClass, expectedClass);
        
    }
}

-(void)testCreateAnObjectThatDoesNotExistInFactory
{
    
    GHAssertThrows([factory createObject:@"hello"], @"Factory did not throw exception for a non existant prototype");
    
        
}





@end
