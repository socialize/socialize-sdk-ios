//
//  SocializeThirdParty.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"

@protocol SocializeThirdParty

+ (BOOL)available;
+ (NSString*)thirdPartyName;
+ (BOOL)isLinkedToSocialize;
+ (NSError*)thirdPartyUnavailableError;
+ (NSError*)userAbortedAuthError;
+ (BOOL)hasLocalCredentials;
+ (void)removeLocalCredentials;

// The information used for linking to Socialize
+ (NSString*)socializeAuthToken;
+ (NSString*)socializeAuthTokenSecret;
+ (SocializeThirdPartyAuthType)socializeAuthType;

@end

@interface SocializeThirdParty : NSObject
+ (NSArray*)allThirdParties;
+ (Class<SocializeThirdParty>)thirdPartyWithName:(NSString*)name;

@end