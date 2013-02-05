//
//  SocializePrivateDefinitions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#define kSOCIALIZE_AUTHENTICATED_USER_KEY  @"SOCIALIZE_AUTHENTICATED_USER_KEY"


#define kPROVIDER_NAME          @"SOCIALIZE"
#define kPROVIDER_PREFIX        @"AUTH"

#define kFACEBOOK_ACCESS_TOKEN_KEY @"FBAccessTokenKey"
#define kFACEBOOK_EXPIRATION_DATE_KEY @"FBExpirationDateKey"

#define kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY @"SOCIALIZE_DONT_POST_TO_FACEBOOK_KEY"
#define kSOCIALIZE_DONT_POST_TO_TWITTER_KEY @"kSOCIALIZE_DONT_POST_TO_TWITTER_KEY"

#define MIN_MODAL_DISMISS_INTERVAL 0.75

#define SOCIALIZE_FACEBOOK_NOT_CONFIGURED_MESSAGE @"Socialize Warning: Facebook is not configured. Facebook UI controls will not be shown. You should consider enabling Socialize's Facebook support, as described in http://socialize.github.com/socialize-sdk-ios/getting_started.html"
#define SOCIALIZE_FACEBOOK_CANNOT_OPEN_URL_MESSAGE @"Socialize Warning: Application cannot open facebook url"
#define SOCIALIZE_TWITTER_NOT_CONFIGURED_MESSAGE @"Socialize Warning: Twitter is not configured. Twitter UI controls will not be shown. You should consider enabling Socialize's Twitter support, as described in http://socialize.github.com/socialize-sdk-ios/twitter.html"
#define SOCIALIZE_NOTIFICATIONS_NOT_CONFIGURED_MESSAGE @"Socialize Warning: SmartAlerts are not configured. SmartAlerts UI controls will not be shown. You can read about Socialize's SmartAlerts at http://socialize.github.com/socialize-sdk-ios/push_notifications.html"

extern NSString *const kSocializeDeviceTokenKey;

typedef enum {
    SocializeRequestStateFailed = -1,
    SocializeRequestStateNotStarted,
    SocializeRequestStateSent,
    SocializeRequestStateFinished
} SocializeRequestState;

#define WEAK(v) __block __unsafe_unretained __typeof__(v)