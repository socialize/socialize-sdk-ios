//
//  SocializeThirdParty.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeCommonDefinitions.h"

@protocol SocializeThirdPartyBase <NSObject>


@end

@protocol SocializeThirdParty <SocializeThirdPartyBase>

+ (BOOL)available;
+ (NSString*)thirdPartyName;
+ (BOOL)isLinkedToSocialize;
+ (NSError*)thirdPartyUnavailableError;
+ (NSError*)userAbortedAuthError;
+ (BOOL)hasLocalCredentials;
+ (void)removeLocalCredentials;
+ (SZSocialNetwork)socialNetworkFlag;
+ (NSString*)dontPostKey;

// The information used for linking to Socialize
+ (NSString*)socializeAuthToken;
+ (NSString*)socializeAuthTokenSecret;
+ (SocializeThirdPartyAuthType)socializeAuthType;
+ (BOOL)userPrefersPost;
+ (BOOL)shouldAutopost;

@end

@interface SocializeThirdParty : NSObject
+ (NSArray*)allThirdParties;
+ (Class<SocializeThirdParty>)thirdPartyWithName:(NSString*)name;
+ (BOOL)thirdPartyLinked;
+ (BOOL)thirdPartyAvailable;
+ (SZSocialNetwork)preferredNetworks;
+ (Class<SocializeThirdParty>)thirdPartyForSocialNetworkFlag:(SZSocialNetwork)network;

@end