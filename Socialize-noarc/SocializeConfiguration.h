//
//  SocializeConfiguration.h
//  SocializeSDK
//
//  Created by William M. Johnson on 5/19/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kSocializeModuleConfigurationPrototypesKey;
extern NSString * const kSocializeModuleConfigurationFormatterKey;
extern NSString * const kRestserverBaseURL;
extern NSString * const kSecureRestserverBaseURL;
extern NSString * const kRedirectBaseURL;

@interface SocializeConfiguration : NSObject 
{
    @private
        NSDictionary * _configurationInfo;
        NSString * _configurationFilePath;
      
}

-(id)initWithWithConfigurationPath:(NSString *)configurationFilePath;

+(NSString *)defaultConfigurationPath;
+(SocializeConfiguration*)sharedConfiguration;
@property(nonatomic, readonly) NSDictionary * configurationInfo;
@property(nonatomic, readonly) NSString * configurationFilePath;
@property(nonatomic, readonly) NSString * defaultConfigurationPath;
@property(nonatomic, copy, readonly) NSString * restserverBaseURL;
@property(nonatomic, copy, readonly) NSString * secureRestserverBaseURL;
@property(nonatomic, copy, readonly) NSString * redirectBaseURL;
@end