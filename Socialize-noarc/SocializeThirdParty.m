
//
//  SocializeThirdParty.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/1/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeThirdParty.h"

#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"

@implementation SocializeThirdParty

+ (NSArray*)allThirdParties {
    return [NSArray arrayWithObjects:[SocializeThirdPartyTwitter class], [SocializeThirdPartyFacebook class], nil];
}

+ (Class<SocializeThirdParty>)thirdPartyWithName:(NSString*)name {
    name = [name lowercaseString];
    for (Class<SocializeThirdParty> thirdParty in [self allThirdParties]) {
        if ([[[thirdParty thirdPartyName] lowercaseString] isEqualToString:name]) {
            return thirdParty;
        }
    }
    return nil;
}

+ (BOOL)thirdPartyLinked {
    for (id<SocializeThirdParty> thirdParty in [self allThirdParties]) {
        if ([thirdParty isLinkedToSocialize]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)thirdPartyAvailable {
    for (id<SocializeThirdParty> thirdParty in [self allThirdParties]) {
        if ([thirdParty available]) {
            return YES;
        }
    }
    return NO;
}

+ (SZSocialNetwork)preferredNetworks {
    SZSocialNetwork networks = SZSocialNetworkNone;
    for (Class<SocializeThirdParty> thirdParty in [self allThirdParties]) {
        if ([thirdParty userPrefersPost]) {
            networks |= [thirdParty socialNetworkFlag];
        }
    }
    
    return networks;
}

+ (Class<SocializeThirdParty>)thirdPartyForSocialNetworkFlag:(SZSocialNetwork)network {
    for (Class<SocializeThirdParty> thirdParty in [self allThirdParties]) {
        if ([thirdParty socialNetworkFlag] == network) {
            return thirdParty;
        }
    }
    
    return nil;
}

@end