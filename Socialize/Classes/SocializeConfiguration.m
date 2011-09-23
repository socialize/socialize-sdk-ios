//
//  SocializeConfiguration.m
//  SocializeSDK
//
//  Created by William M. Johnson on 5/19/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeConfiguration.h"

NSString * const kSocializeModuleConfigurationPrototypesKey = @"Prototypes";
NSString * const kSocializeModuleConfigurationFormatterKey = @"Formatters";

@interface SocializeConfiguration ()

-(NSDictionary *)retrieveConfigurationDataFromFileAtPath:(NSString *)configurationPath;

@end


@implementation SocializeConfiguration

@synthesize configurationInfo = _configurationInfo;
@synthesize configurationFilePath = _configurationFilePath;

- (void)dealloc 
{
    [_configurationInfo release]; 
    [_configurationFilePath release];
    [super dealloc];
}

- (id)init 
{
    return [self initWithWithConfigurationPath:nil];
}

-(id)initWithWithConfigurationPath:(NSString *)configurationPath
{
    self = [super init];
    if (self) 
    {
        NSString * tempConfigurationPath =  (configurationPath!=nil)? configurationPath:[SocializeConfiguration defaultConfigurationPath];
        
        NSDictionary * newConfigurationIfo = [self retrieveConfigurationDataFromFileAtPath:tempConfigurationPath];
        
        NSAssert(newConfigurationIfo!=nil,
                 @"Configuration information was not found at path ->%@", tempConfigurationPath);
        
        NSAssert([newConfigurationIfo count]> 0, @"Configuration information is empty (Path-> %@)", tempConfigurationPath);
        
        
        
        _configurationFilePath = [tempConfigurationPath copy];         
        _configurationInfo = [newConfigurationIfo retain];
    }
    return self; 
    
}
-(NSString *)defaultConfigurationPath
{
    return [SocializeConfiguration defaultConfigurationPath];    
}

+(NSString *)defaultConfigurationPath
{
    NSBundle * bundle =  [NSBundle bundleForClass:[self class]];
    NSString * configPath = [bundle pathForResource:@"SocializeConfigurationInfo" ofType:@"plist"];

    return  configPath;
}

-(NSDictionary *)retrieveConfigurationDataFromFileAtPath:(NSString *)configurationPath
{
    
    NSDictionary * configurationDictionary = [[NSDictionary alloc]initWithContentsOfFile:configurationPath];
    return  [configurationDictionary autorelease];
  
}

@end