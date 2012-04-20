//
//  SocializeCommonDefinitions.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/15/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeErrorDefinitions.h"
#import "SocializeVersion.h"

/** 
 Third party authentication type 
*/
typedef enum SocializeThirdPartyAuthType {
    SocializeThirdPartyAuthTypeFacebook = 1,
    SocializeThirdPartyAuthTypeTwitter = 2
} SocializeThirdPartyAuthType;

typedef enum {
    SocializeShareMediumTwitter = 1,
    SocializeShareMediumFacebook = 2,
    SocializeShareMediumEmail = 3,
    SocializeShareMediumSMS = 4,
    SocializeShareMediumOther = 101
} SocializeShareMedium;

typedef enum {
    SocializeCommentActivity,
    SocializeLikeActivity,
    SocializeShareActivity,
    SocializeViewActivity,
    SocializeAllActivity
} SocializeActivityType;

extern NSString *const kSocializeConsumerKey;
extern NSString *const kSocializeConsumerSecret;

// Notifications
extern NSString *const SocializeAuthenticatedUserDidChangeNotification;
extern NSString *const SocializeCLAuthorizationStatusDidChangeNotification;
extern NSString *const kSocializeCLAuthorizationStatusKey;
extern NSString *const kSocializeShouldShareLocationKey;
extern NSString *const SocializeDidRegisterDeviceTokenNotification;
extern NSString *const SocializeLikeButtonDidChangeStateNotification;

// Twitter
extern NSString *const kSocializeTwitterAuthConsumerKey;
extern NSString *const kSocializeTwitterAuthConsumerSecret;
extern NSString *const kSocializeTwitterAuthAccessToken;
extern NSString *const kSocializeTwitterAuthAccessTokenSecret;
extern NSString *const kSocializeTwitterAuthScreenName;
extern NSString *const kSocializeTwitterAuthUserId;
extern NSString *const kSocializeTwitterStringForAPI;

// Facebook
extern NSString *const kSocializeFacebookAuthAppId;
extern NSString *const kSocializeFacebookAuthLocalAppId;
extern NSString *const kSocializeFacebookAuthAccessToken;
extern NSString *const kSocializeFacebookAuthExpirationDate;
extern NSString *const kSocializeFacebookStringForAPI;

extern NSString *const kSocializeAuthenticationNotRequired;
extern NSString *const kSocializeAnonymousAllowed;

#define SOCIALIZE_API_KEY @"socialize_api_key"
#define SOCIALIZE_API_SECRET @"socialize_api_secret"
#define SOCIALIZE_FACEBOOK_LOCAL_APP_ID @"socialize_facebook_local_app_id"
#define SOCIALIZE_FACEBOOK_APP_ID @"socialize_facebook_app_id"
#define SOCIALIZE_APPLICATION_LINK @"socialize_app_link"
extern NSString *const SocializeUIControllerDidFailWithErrorNotification;
extern NSString *const SocializeUIControllerErrorUserInfoKey;

extern NSString *const kSocializeUIErrorAlertsDisabled;
