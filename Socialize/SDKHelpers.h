//
//  SDKHelpers.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"
#import "SZActivityOptions.h"

@class SZShareOptions;

typedef enum {
    SZLinkContextComment,
    SZLinkContextLike,
} SZLinkContext;

void SZShowLinkToFacebookAlertView(void (^okBlock)(), void (^cancelBlock)());
SZSocialNetwork SZLinkedSocialNetworks();
SZSocialNetwork SZAvailableSocialNetworks();
typedef void (^ActivityCreatorBlock)(id<SZActivity>, void(^)(id<SZActivity>), void(^)(NSError*));
typedef SZSocialNetworkPostData *(^SZPostDataBuilderBlock)(id<SZActivity>activity);
SZPostDataBuilderBlock SZDefaultLinkPostData();
SocializeShareMedium SocializeShareMediumForSZSocialNetworks(SZSocialNetwork networks);
void SZCreateAndShareActivity(id<SZActivity> activity, SZPostDataBuilderBlock, SZActivityOptions *options, SZSocialNetwork networks, ActivityCreatorBlock creator, void (^success)(id<SZActivity> activity), void (^failure)(NSError *error));
SZActivityOptions *SZActivityOptionsFromUserDefaults(Class optionsClass);
BOOL SZShouldShowLinkDialog();
BOOL SZShouldShowNetworkSelection();
BOOL SZErrorsAreDisabled();
void SZEmitUIError(id object, NSError *error);
void SZAuthWrapper(void (^success)(), void (^failure)(NSError *error));
void SZLinkAndGetPreferredNetworks(UIViewController *viewController, SZLinkContext context, void (^completion)(SZSocialNetwork preferredNetworks), void (^cancellation)());
BOOL SZShouldShareLocation();
void SZFBAuthWrapper( void (^success)(), void (^failure)(NSError *error));
void SZTWAuthWrapper(UIViewController *viewController, void (^success)(), void (^failure)(NSError *error));
BOOL SZOSGTE(NSString *minVersion);
void SZEmitUnconfiguredFacebookMessage();
void SZEmitUnconfiguredTwitterMessage();
void SZEmitUnconfiguredSmartAlertsMessage();
NSStringEncoding NSStringEncodingForURLResponse(NSHTTPURLResponse *response);
NSString *NSStringForHTTPURLResponse(NSHTTPURLResponse* response, NSData *data);
