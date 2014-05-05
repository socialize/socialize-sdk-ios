//
//  Header.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/2/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//


// Error Definitions
extern NSString *const SocializeErrorDomain;

// userInfo keys for specific errors
extern NSString *const kSocializeErrorResponseBodyKey;
extern NSString *const kSocializeErrorServerErrorsArrayKey;
extern NSString *const kSocializeErrorServerObjectsArrayKey;
extern NSString *const kSocializeErrorNSHTTPURLResponseKey;

typedef enum {
    SocializeErrorUnknown = -1,
    SocializeErrorUnexpectedJSONResponse,
    SocializeErrorServerReturnedErrors,
    SocializeErrorServerReturnedHTTPError,
    SocializeErrorFacebookCancelledByUser,
    SocializeErrorFacebookUnavailable,
    SocializeErrorFacebookAuthRestarted,
    SocializeErrorFacebookAuthFailed,
    SocializeErrorTwitterCancelledByUser,
    SocializeErrorTwitterUnavailable,
    SocializeErrorSMSNotAvailable,
    SocializeErrorEmailNotAvailable,
    SocializeErrorShareCreationFailed,
    SocializeErrorShareCancelledByUser,
    SocializeErrorThirdPartyNotLinked,
    SocializeErrorThirdPartyNotAvailable,
    SocializeErrorThirdPartyLinkCancelledByUser,
    SocializeErrorProcessCancelledByUser,
    SocializeErrorCommentCancelledByUser,
    SocializeErrorLocationUpdateRejectedByUser,
    SocializeErrorLocationUpdateTimedOut,
    SocializeErrorLinkCancelledByUser,
    SocializeErrorLinkNotPossible,
    SocializeErrorNetworkSelectionCancelledByUser,
    SocializeErrorSMSSendFailure,
    SocializeErrorLikeCancelledByUser,
    SocializeErrorRequestCancelled,
    SocializeErrorEntityLoadRejected,
    SocializePinterestNotAvailable,
    SocializePinterestShareFailed,
    SocializeWhatsAppNotAvailable,
    SocializeWhatsAppShareFailed,
    SocializeWhatsAppShareCancelledByUser,
    SocializeNumErrors,
} SocializeErrorCode;

NSString *SocializeDefaultErrorStringForCode(NSUInteger code);
NSString *SocializeDefaultLocalizedErrorStringForCode(NSUInteger code);