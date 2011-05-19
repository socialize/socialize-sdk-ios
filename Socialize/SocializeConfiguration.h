//
//  SocializeConfiguration.h
//  SocializeSDK
//
//  Created by William M. Johnson on 5/19/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kSocializeModuleConfigurationPrototypesKey;

@interface SocializeConfiguration : NSObject 
{
    @private
        NSDictionary * _configurationInfo;
        NSString * _configurationFilePath;
      
}

-(id)initWithWithConfigurationPath:(NSString *)configurationFilePath;

@property(nonatomic, readonly) NSDictionary * configurationInfo;


@end