//
//  SocializeConfiguration.m
//  SocializeSDK
//
//  Created by William M. Johnson on 5/19/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeConfiguration.h"

NSString * const kSocializeModuleConfigurationPrototypesKey = @"Prototypes";

@interface SocializeConfiguration ()

-(NSDictionary *)retrieveConfigurationDataFromFileAtPath:(NSString *)filePath;
@end


@implementation SocializeConfiguration

@synthesize configurationInfo = _configurationInfo;

- (void)dealloc 
{
    [_configurationInfo release]; 
    [super dealloc];
}

- (id)init 
{
    NSBundle * bundle =  [NSBundle bundleForClass:[self class]];
    
    NSString * configPath = [bundle pathForResource:@"SocializeConfigurationInfo" ofType:@"plist"];

    return [self initWithWithConfigurationPath:configPath];
}

-(id)initWithWithConfigurationPath:(NSString *)configurationFilePath
{
    self = [super init];
    if (self) 
    {
        _configurationInfo = [[self retrieveConfigurationDataFromFileAtPath:configurationFilePath]retain];
    }
    return self; 
    
}


-(NSDictionary *)retrieveConfigurationDataFromFileAtPath:(NSString *)filePath
{
    
    NSAssert((filePath!=nil && ([filePath length]> 3)), @"SocializeConfiguration : Invalid file path-> %@",filePath);    
    NSDictionary * configurationDictionary = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    
    return  configurationDictionary;
  
}

@end