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

typedef enum {
    SZResultSortingDefault,
    SZResultSortingMostRecent = SZResultSortingDefault,
    SZResultSortingPopularity,
} SZResultSorting;

/** 
 Third party authentication type 
*/
typedef enum SocializeThirdPartyAuthType {
    SocializeThirdPartyAuthTypeFacebook = 1,
    SocializeThirdPartyAuthTypeTwitter = 2
} SocializeThirdPartyAuthType;

typedef enum SZSocialNetwork {
    SZSocialNetworkNone = 0,
    SZSocialNetworkFacebook = 1 << 0,
    SZSocialNetworkTwitter = 1 << 1,
} SZSocialNetwork;

typedef enum {
    SocializeShareMediumTwitter = 1,
    SocializeShareMediumFacebook = 2,
    SocializeShareMediumEmail = 3,
    SocializeShareMediumSMS = 4,
    SocializeShareMediumPinterest = 5,
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
extern NSString *const kSocializeAccessToken;
extern NSString *const kSocializeAccessTokenSecret;

// Notifications
extern NSString *const SocializeAuthenticatedUserDidChangeNotification;

extern NSString *const SZEntityDidChangeNotification;

extern NSString *const SZUserSettingsDidChangeNotification;
extern NSString *const kSZUpdatedUserSettingsKey;
extern NSString *const kSZUpdatedUserKey;

extern NSString *const SZDidCreateObjectsNotification;
extern NSString *const kSZCreatedObjectsKey;

extern NSString *const SZDidDeleteObjectsNotification;
extern NSString *const kSZDeletedObjectsKey;

extern NSString *const SZDidFetchObjectsNotification;
extern NSString *const kSZFetchedObjectsKey;

extern NSString *const SocializeCLAuthorizationStatusDidChangeNotification;
extern NSString *const kSocializeCLAuthorizationStatusKey;
extern NSString *const kSocializeShouldShareLocationKey;
extern NSString *const SocializeDidRegisterDeviceTokenNotification;
extern NSString *const SZLikeButtonDidChangeStateNotification;
extern NSString *const SZLocationDidChangeNotification;
extern NSString *const kSZNewLocationKey;

extern NSString *const SocializeShouldDismissAllNotificationControllersNotification;

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
extern NSString *const kSocializeLocationSharingDisabled;

extern NSString *const kSocializeAnonymousAllowed;

extern NSString *const kSocializeDontPostToFacebookKey;
extern NSString *const kSocializeDontPostToTwitterKey;
extern NSString *const kSocializeAutoPostToSocialNetworksKey;


#define SOCIALIZE_API_KEY @"socialize_api_key"
#define SOCIALIZE_API_SECRET @"socialize_api_secret"
#define SOCIALIZE_FACEBOOK_LOCAL_APP_ID @"socialize_facebook_local_app_id"
#define SOCIALIZE_FACEBOOK_APP_ID @"socialize_facebook_app_id"
#define SOCIALIZE_APPLICATION_LINK @"socialize_app_link"
extern NSString *const SocializeUIControllerDidFailWithErrorNotification;
extern NSString *const SocializeUIControllerErrorUserInfoKey;

extern NSString *const kSocializeUIErrorAlertsDisabled;

@class _SZUserSettingsViewController;
@class _SZUserProfileViewController;
@class _SZCommentsListViewController;
@class _SZComposeCommentViewController;
@class SocializeActionBar;
@class SZLikeButton;
@protocol _SZUserSettingsViewControllerDelegate;
@protocol SocializeActionBarDelegate;

typedef _SZUserSettingsViewController SocializeProfileEditViewController __attribute__((deprecated("Please use SZUserSettingsViewController or the utility functions in SZUserUtils")));
#define SocializeProfileEditViewControllerDelegate _SZUserSettingsViewControllerDelegate

typedef _SZUserProfileViewController SocializeProfileViewController __attribute__((deprecated("Please use SZUserProfileViewController or the utility functions in SZUserUtils")));
typedef _SZCommentsListViewController SocializeCommentsTableViewController __attribute__((deprecated("Please use SZCommentsListViewController or the utility functions in SZCommentUtils")));
typedef _SZComposeCommentViewController SocializeComposeCommentViewController __attribute__((deprecated("Please use SZComposeCommentViewController or the utility functions in SZCommentUtils")));
//typedef SocializeActionBar SocializeActionBar __attribute__((deprecated("Please use SocializeActionBar or the utility functions in SocializeActionBarUtils")));
//#define SocializeActionBarDelegate SocializeActionBarDelegate
typedef SZLikeButton SocializeLikeButton __attribute__((deprecated("Please use SZLikeButton")));

@protocol SocializeEntity;
@protocol SocializeComment;
typedef void(^SocializeEntityLoaderBlock)(UINavigationController *navigationController, id<SocializeEntity>entity);
typedef void(^SocializeNewCommentsNotificationBlock)(id<SocializeComment>comment);
typedef BOOL(^SocializeCanLoadEntityBlock)(id<SocializeEntity>entity);

#define SZActivity SocializeActivity
#define SZApplication SocializeApplication
#define SZComment SocializeComment
#define SZDeviceToken SocializeDeviceToken
#define SZEntity SocializeEntity
#define SZObject SocializeObject
#define SZUser SocializeUser
#define SZFullUser SocializeFullUser
#define SZLike SocializeLike
#define SZView SocializeView
#define SZShare SocializeShare
#define SZSubscription SocializeSubscription
#define SZError SocializeError

#define BLOCK_CALL(blk) do { if (blk != nil) blk(); } while (0)
#define BLOCK_CALL_1(blk, arg1) do { if (blk != nil) blk(arg1); } while (0)
#define BLOCK_CALL_2(blk, arg1, arg2) do { if (blk != nil) blk(arg1, arg2); } while (0)
#define BLOCK_CALL_3(blk, arg1, arg2, arg3) do { if (blk != nil) blk(arg1, arg2, arg3); } while (0)
