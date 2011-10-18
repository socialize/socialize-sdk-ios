//
//  SocializeObjectTests.m
//  SocializeSDK
//
//  Created by William Johnson on 5/16/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//
#import <OCMock/OCMock.h>
#import "SocializeComment.h"
#import "SocializePOOCObjectFactoryTests.h"
#import "SocializeObject.h"
#import "SocializePOOCObjectFactory.h"
#import "SocializeConfiguration.h"
#import "JSONKit.h"

@interface SocializePOOCObjectFactoryTests ()
-(id)helperCreateMockConfigurationWithPrototypeConfiguration:(NSDictionary *)prototypeConfiguration;
-(id)helperCreateMockConfigurationWithPrototypeConfiguration:(NSDictionary *)prototypeConfiguration 
                                      formatterConfiguration: (NSDictionary*) formatterConfiguration;
-(void)helperTestThatPrototypesExistsForPrototypeConfiguration:(NSDictionary *)prototypeConfiguration 
                                                     inFactory:(SocializePOOCObjectFactory *)theTestFactory;
@end

@implementation SocializePOOCObjectFactoryTests


- (void)setUpClass 
{
    
}


- (void)tearDownClass 
{
}

- (void)setUp 
{
    // Run before each test method
}

- (void)tearDown 
{
    // Run after each test method
}  

//-(void)testAddProtocolsThatAreNOTSupportted
//{
//    
//    GHAssertThrows([factory  addPrototype:[NSURL class] forKey:@"NSURL"],
//                   @"Factory did not throw exception when adding a unsupported prototype");
//}
-(void)testCreateFactoryWithConfigurationInjection
{
    NSDictionary * prototypeConfiguration = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"SocializeComment",@"SocializeComment", 
                                          @"SocializeEntity", @"SocializeEntity",
                                          nil];
    
    NSDictionary * formatterConfiguration = [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"SocializeCommentJSONFormatter",@"SocializeComment", 
                                             @"SocializeEntityJSONFormatter", @"SocializeEntity",
                                             nil];
    
    
    id mockConfiguration = [self helperCreateMockConfigurationWithPrototypeConfiguration:prototypeConfiguration formatterConfiguration:formatterConfiguration];   
    
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]initWithConfiguration:mockConfiguration]autorelease];
    
    [self helperTestThatPrototypesExistsForPrototypeConfiguration:prototypeConfiguration inFactory:myTestFactory];
 
}

-(void)testCreateFactoryWithDefaultConfiguration
{
    
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]init]autorelease];
    SocializeConfiguration * defaultConfiguration = [[[SocializeConfiguration alloc]init]autorelease];
    
    NSDictionary * defaultPrototypeConfiguration = [defaultConfiguration.configurationInfo objectForKey:kSocializeModuleConfigurationPrototypesKey];
    
    [self helperTestThatPrototypesExistsForPrototypeConfiguration:defaultPrototypeConfiguration inFactory:myTestFactory];
   
}

-(void)testCreateObjectFromString
{
    NSString* jsonApplication = @"{\"id\":123,\"name\":\"test application\"}";
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]init] autorelease];
    
    id<SocializeApplication> actualResult = [myTestFactory createObjectFromString:jsonApplication forProtocol:@protocol(SocializeApplication)];
    
    GHAssertTrue(actualResult.objectID == 123, nil);
    GHAssertEqualStrings(actualResult.name, @"test application", nil);
}

-(void)testCreateObjectFromDictionary
{
    
    NSDictionary * jsonApplication = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:123], @"id", @"test application", @"name", nil];
    
    ;
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]init] autorelease];
    
    id<SocializeApplication> actualResult = [myTestFactory createObjectFromDictionary:jsonApplication forProtocol:@protocol(SocializeApplication)];
    
    GHAssertTrue(actualResult.objectID == 123, nil);
    GHAssertEqualStrings(actualResult.name, @"test application", nil);
    
}

-(void)testCreateStringRepresentationOfObject
{
    NSString* expectedResult = @"{\"id\":123,\"name\":\"test application\"}";
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]init]autorelease];
    
    id mockSocializeApplication = [OCMockObject mockForProtocol:@protocol(SocializeApplication)];

    int ID = 123;
    [[[mockSocializeApplication stub] andReturnValue:OCMOCK_VALUE(ID)]objectID];
    [[[mockSocializeApplication stub] andReturn:@"test application"]name];
    
    NSString* actualResult = [myTestFactory createStringRepresentationOfObject:mockSocializeApplication];

    GHAssertEqualStrings(expectedResult, actualResult, nil);
}

-(void)testCreateDictionaryRepresentationOfObject
{
    NSDictionary * expectedResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:123], @"id", @"test application", @"name", nil];
    
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]init]autorelease];
    
    id mockSocializeApplication = [OCMockObject mockForProtocol:@protocol(SocializeApplication)];
    
    int ID = 123;
    [[[mockSocializeApplication stub] andReturnValue:OCMOCK_VALUE(ID)]objectID];
    [[[mockSocializeApplication stub] andReturn:@"test application"]name];
    
    NSDictionary* actualResult = [myTestFactory createDictionaryRepresentationOfObject:mockSocializeApplication];
    
   GHAssertEqualObjects(expectedResult, actualResult, nil);
}

-(void)testCreateStringRepresentationOfArray
{
    
   id mockSocializeObject1 = [OCMockObject niceMockForProtocol:@protocol(SocializeEntity)];
   id mockSocializeObject2 = [OCMockObject niceMockForProtocol:@protocol(SocializeEntity)];
   
//    NSDictionary * dictionary1 = [NSDictionary dictionaryWithObject:@"mockSocializeObject1Key" forKey:@"key"];
//    NSDictionary * dictionary2 = [NSDictionary dictionaryWithObject:@"mockSocializeObject2Key" forKey:@"key"];
//    
    int intValue = 2;
    
    
    [[[mockSocializeObject1 expect]andReturn:@"mockSocializeObject1Key"]key];
    [[[mockSocializeObject1 expect]andReturn:@"mockSocializeObject1Name"]name];
    
    [[[mockSocializeObject2 expect]andReturn:@"mockSocializeObject2Key"]key];
    [[[mockSocializeObject2 expect]andReturn:@"mockSocializeObject2Name"]name];
    
    NSArray * entitiesArray = [NSArray arrayWithObjects:mockSocializeObject1, mockSocializeObject2,[NSNumber numberWithInt:intValue] ,nil];
    
    
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]init]autorelease];
    
    [myTestFactory createStringRepresentationOfArray:entitiesArray];
    
//   NSString * expectedString = [[NSArray arrayWithObjects:dictionary1,dictionary2,[NSNumber numberWithInt:intValue] ,nil]JSONString];
//    
//    GHAssertEqualStrings(expectedString, actualString,@"Strings not equal");
}



-(void)testCreateFactoryWithNilOrEmptyConfiguration
{

    
    //Configuration is nil
    GHAssertThrows([[[SocializePOOCObjectFactory alloc]initWithConfiguration:nil]autorelease],
                   @"Should throw exception");

    
    //Configuration NOT nil, configInfo nil
    id mockConfiguration1 = [OCMockObject mockForClass:[SocializeConfiguration class]];
    [[[mockConfiguration1 stub] andReturn:nil] configurationInfo];
    
    GHAssertThrows([[[SocializePOOCObjectFactory alloc]initWithConfiguration:mockConfiguration1]autorelease],
                   @"Should throw exception");
    
    
    //Configuration NOT nil, ConfigInfo Empty, prototypes nil
    id mockConfiguration2 = [self helperCreateMockConfigurationWithPrototypeConfiguration:nil];
    GHAssertThrows([[[SocializePOOCObjectFactory alloc]initWithConfiguration:mockConfiguration2]autorelease],
                   @"Should throw exception");
    
    
    //Configuration NOT nil, ConfigInfo NOT Empty, prototypes Empty
    id mockConfiguration3 = [self helperCreateMockConfigurationWithPrototypeConfiguration:
                              [[[NSDictionary alloc]init]autorelease]];
    
    GHAssertThrows([[[SocializePOOCObjectFactory alloc]initWithConfiguration:mockConfiguration3]autorelease],
                   @"Should throw exception");
   
}



-(void)testAddPrototypesToFactoriesThatAreNotSocializeObjects
{
    id mockObject = [OCMockObject mockForClass:[NSObject class]];
    [[mockObject expect] conformsToProtocol:[OCMArg any]];
    
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]init]autorelease];
    
    GHAssertThrows([myTestFactory  addPrototype:mockObject forKey:@"SocializeComment"],
                   @"Factory did not throw exception when adding a non socialize object");
    
    [mockObject verify];
   
   
    NSDictionary * prototypeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"NSBundle",@"SocializeComment", nil];
    
    id mockConfiguration = [self helperCreateMockConfigurationWithPrototypeConfiguration:prototypeDictionary];
    
    
    GHAssertThrows([[[SocializePOOCObjectFactory alloc]initWithConfiguration:mockConfiguration]autorelease],
                   @"Should throw exception");
    
}


-(void)testCreateAnObjectThatDoesNotExistInFactory
{
    
    SocializePOOCObjectFactory * myTestFactory = [[[SocializePOOCObjectFactory alloc]init]autorelease];
    
    GHAssertThrows([myTestFactory createObjectForProtocolName:@"hello"], @"Factory did not throw exception for a non existant prototype");
    
}


#pragma mark helper methods
-(void)helperTestThatPrototypesExistsForPrototypeConfiguration:(NSDictionary *)prototypeConfiguration 
                                                     inFactory:(SocializePOOCObjectFactory *)theTestFactory
{
    NSString * prototypeClassName = nil;
    for (NSString * protocolName in [prototypeConfiguration allKeys]) 
    {
        prototypeClassName = (NSString *)[prototypeConfiguration objectForKey:protocolName]; 
        
        
        Class expectedClass = NSClassFromString(prototypeClassName);
        
        id actualObject = [theTestFactory createObjectForProtocol:NSProtocolFromString(protocolName)];
        
        Class actualClass = [actualObject class];
        
        GHAssertTrue(actualClass == expectedClass,
                     @"Actual ->%@ : Expected -> %@ -- wrong class returned from [factory createObject:prototypeKey].",
                     actualClass, expectedClass);
        
    }

}

-(id)helperCreateMockConfigurationWithPrototypeConfiguration:(NSDictionary *)prototypeConfiguration
{
    return [self helperCreateMockConfigurationWithPrototypeConfiguration: prototypeConfiguration formatterConfiguration: nil];
}

-(id)helperCreateMockConfigurationWithPrototypeConfiguration:(NSDictionary *)prototypeConfiguration 
                                      formatterConfiguration: (NSDictionary*) formatterConfiguration
{
    id mockConfiguration = [OCMockObject mockForClass:[SocializeConfiguration class]];
    
    NSDictionary * configurationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              (prototypeConfiguration != nil) ? prototypeConfiguration : [[[NSDictionary alloc]init]autorelease], kSocializeModuleConfigurationPrototypesKey,
                                              (formatterConfiguration != nil) ? formatterConfiguration : [[[NSDictionary alloc]init]autorelease], kSocializeModuleConfigurationFormatterKey,
                                              nil];
    
    [[[mockConfiguration stub] andReturn:configurationDictionary] configurationInfo];
    
    return  mockConfiguration;
}



@end
