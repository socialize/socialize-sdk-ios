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
    SocializeShareMediumOther = 3
} SocializeShareMedium;

typedef enum {
    SocializeCommentActivity,
    SocializeLikeActivity,
    SocializeShareActivity,
    SocializeViewActivity,
    SocializeAllActivity
} SocializeActivityType;

extern NSString *const SocializeAuthenticatedUserDidChangeNotification;

extern NSString *const kSocializeTwitterAuthConsumerKey;
extern NSString *const kSocializeTwitterAuthConsumerSecret;
extern NSString *const kSocializeTwitterAuthAccessToken;
extern NSString *const kSocializeTwitterAuthAccessTokenSecret;
extern NSString *const kSocializeTwitterAuthScreenName;
