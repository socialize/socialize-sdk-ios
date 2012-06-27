//
//  SocializeConfigurationTests.m
//  SocializeSDK
//
//  Created by William Johnson on 5/19/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeConfigurationTests.h"
#import "SocializeConfiguration.h"

@interface SocializeConfigurationTests()

-(NSString *)helperFullPathForfileName:(NSString *)fileName;

@end

@implementation SocializeConfigurationTests

-(void)testDefaultConfiguration
{
    NSString * expectedDefaultConfiguationPath = [self helperFullPathForfileName:@"SocializeConfigurationInfo.plist"];
    
    NSDictionary * expectedConfigurationDictionary = [[[NSDictionary alloc]initWithContentsOfFile:expectedDefaultConfiguationPath]autorelease];
    
    
    SocializeConfiguration * actualConfiguration = [[[SocializeConfiguration alloc]init]autorelease];
    
    GHAssertTrue([[SocializeConfiguration defaultConfigurationPath]isEqual:expectedDefaultConfiguationPath],  
                  @"Default Configuration - [SocializeConfiguration defaultConfigurationPath] should equal expectedDefaultConfiguationPath.");
                  
    
    GHAssertTrue([actualConfiguration.defaultConfigurationPath isEqual:[SocializeConfiguration defaultConfigurationPath]],  
                 @"Default Configuration - Instance defaultConfigurationPath should equal [SocializeConfiguration defaultConfigurationPath].");
    
    GHAssertTrue([actualConfiguration.configurationFilePath isEqual:actualConfiguration.defaultConfigurationPath],  
                 @"Default Configuration - Instance configurationFilePath should equal Instance defaultConfigurationPath.");
  
    GHAssertTrue([actualConfiguration.configurationInfo isEqualToDictionary:expectedConfigurationDictionary], 
                 @"Default Configuration - actual and expected dictionaries should be the same.");
   
}

-(void)testSuccessfullConfigurationFromFilePath
{
    NSString * expectedConfiguationPath = [self helperFullPathForfileName:@"UnitTest-SocializeConfigurationInfo.plist"];
    
    SocializeConfiguration * actualConfiguration = [[[SocializeConfiguration alloc]initWithWithConfigurationPath:expectedConfiguationPath]autorelease];
    
    NSString * expectedConfigurationValue = @"UnitTestValue";
    NSString * actualConfigurationValue = [actualConfiguration.configurationInfo objectForKey:@"UnitTestKey"];
    
    GHAssertTrue([actualConfigurationValue isEqual:expectedConfigurationValue], @"actual configuration value (%@) should equal expected configuration value (%@)", actualConfigurationValue, expectedConfigurationValue);
}

-(void)testNilConfigurationFilePath
{

    SocializeConfiguration * actualConfiguration = [[[SocializeConfiguration alloc]initWithWithConfigurationPath:nil]autorelease];
   
    
    NSString * expectedDefaultConfiguationPath = [self helperFullPathForfileName:@"SocializeConfigurationInfo.plist"];
   
    GHAssertTrue([actualConfiguration.configurationFilePath isEqual:expectedDefaultConfiguationPath],
                  @"Socialize Configuration - Instance configurationFilePath should equal default configuration path.");
    GHAssertTrue([actualConfiguration.configurationInfo count] > 0,
                   @"Socialize Configuration - configuration info dictionary should not be nil or empty.");
}

-(void)testNonExistantConfigurationFilePath
{   
    NSString * nonExistantFilePath = @"blahblkajflsfd";
    GHAssertThrows([[[SocializeConfiguration alloc]initWithWithConfigurationPath:nonExistantFilePath]
                     autorelease],
                    @"Socialize Configuration - should have thrown a exception for non existant file path->%@",nonExistantFilePath);
}

-(void)testEmptyConfiguration
{   
    NSString * expectedConfiguationPath = [self helperFullPathForfileName:@"UnitTest-SocializeConfigurationInfo-EMPTY.plist"];
    
    GHAssertThrows([[[SocializeConfiguration alloc]initWithWithConfigurationPath:expectedConfiguationPath]
                    autorelease],
                   @"Socialize Configuration - should have thrown a exception for empty configuration");
    
}
    
#pragma mark helper methods
-(NSString *)helperFullPathForfileName:(NSString *)fileName
{
    NSBundle * bundle =  [NSBundle bundleForClass:[self class]];
    return  [bundle pathForResource:fileName ofType:nil];
}

@end
