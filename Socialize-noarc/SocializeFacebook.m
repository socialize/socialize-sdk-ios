//
//  SocializeFacebook.m
//  Socialize
//
//  Created by David Jedeikin on 10/20/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SocializeFacebook.h"
#import "SocializeFBSessionManualTokenCachingStrategy.h"
#import <FacebookSDK/FBError.h>
#import <FacebookSDK/FBRequest.h>

//static NSString *kRedirectURL = @"fbconnect://success";
//
//static NSString *kLogin = @"oauth";
//static NSString *kApprequests = @"apprequests";
//static NSString *kSDKVersion = @"2";

// If the last time we extended the access token was more than 24 hours ago
// we try to refresh the access token again.
static const int kTokenExtendThreshold = 24;

static NSString *requestFinishedKeyPath = @"state";
static void *finishedContext = @"finishedContext";
static void *tokenContext = @"tokenContext";

// the following const strings name properties for which KVO is manually handled
static NSString *const FBaccessTokenPropertyName = @"accessToken";
static NSString *const FBexpirationDatePropertyName = @"expirationDate";

///////////////////////////////////////////////////////////////////////////////////////////////////

@interface SocializeFacebook () <SocializeFBRequestDelegate>

// private properties
@property (nonatomic, copy) NSString *appId;
// session and tokenCaching object implement login logic and token state in Facebook class
@property (nonatomic, readwrite, retain) FBSession *session;
@property (nonatomic) BOOL hasUpdatedAccessToken;
@property (nonatomic, retain) SocializeFBSessionManualTokenCachingStrategy *tokenCaching;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SocializeFacebook {
    id<SocializeFBSessionDelegate> _sessionDelegate;
    NSMutableSet *_requests;
    FBSession *_session;
//    SocializeFBSessionManualTokenCachingStrategy *_tokenCaching;
//    FBDialog *_fbDialog;
    NSString *_appId;
    NSString *_urlSchemeSuffix;
    BOOL _isExtendingAccessToken;
    FBRequest *_requestExtendingAccessToken;
    NSDate *_lastAccessTokenUpdate;
//    FBFrictionlessRequestSettings *_frictionlessRequestSettings;
}


/**
 * Initialize the Facebook object with application ID.
 *
 * @param appId the facebook app id
 * @param urlSchemeSuffix
 *   urlSchemeSuffix is a string of lowercase letters that is
 *   appended to the base URL scheme used for Facebook Login. For example,
 *   if your facebook ID is "350685531728" and you set urlSchemeSuffix to
 *   "abcd", the Facebook app will expect your application to bind to
 *   the following URL scheme: "fb350685531728abcd".
 *   This is useful if your have multiple iOS applications that
 *   share a single Facebook application id (for example, if you
 *   have a free and a paid version on the same app) and you want
 *   to use Facebook Login with both apps. Giving both apps different
 *   urlSchemeSuffix values will allow the Facebook app to disambiguate
 *   their URL schemes and always redirect the user back to the
 *   correct app, even if both the free and the app is installed
 *   on the device.
 *   urlSchemeSuffix is supported on version 3.4.1 and above of the Facebook
 *   app. If the user has an older version of the Facebook app
 *   installed and your app uses urlSchemeSuffix parameter, the SDK will
 *   proceed as if the Facebook app isn't installed on the device
 *   and redirect the user to Safari.
 * @param delegate the FBSessionDelegate
 */
- (instancetype)initWithAppId:(NSString *)appId
              urlSchemeSuffix:(NSString *)urlSchemeSuffix
                  andDelegate:(id<SocializeFBSessionDelegate>)delegate {
    self = [super init];
    if (self) {
        _requests = [[NSMutableSet alloc] init];
        _lastAccessTokenUpdate = [[NSDate distantPast] retain];
//        _frictionlessRequestSettings = [[FBFrictionlessRequestSettings alloc] init];
        self.tokenCaching = [[SocializeFBSessionManualTokenCachingStrategy alloc] init];
        self.appId = appId;
        self.sessionDelegate = delegate;
        self.urlSchemeSuffix = urlSchemeSuffix;
        
        // observe tokenCaching properties so we can forward KVO
        [self.tokenCaching addObserver:self
                            forKeyPath:FBaccessTokenPropertyName
                               options:NSKeyValueObservingOptionPrior
                               context:tokenContext];
        [self.tokenCaching addObserver:self
                            forKeyPath:FBexpirationDatePropertyName
                               options:NSKeyValueObservingOptionPrior
                               context:tokenContext];
    }
    return self;
}

/**
 * Override NSObject : free the space
 */
- (void)dealloc {
    
    // this is the one case where the delegate is this object
//    _requestExtendingAccessToken.delegate = nil;
    
    [_session release];
    // remove KVOs for tokenCaching
    [self.tokenCaching removeObserver:self forKeyPath:FBaccessTokenPropertyName context:tokenContext];
    [self.tokenCaching removeObserver:self forKeyPath:FBexpirationDatePropertyName context:tokenContext];
    [self.tokenCaching release];

    for (FBRequest *_request in _requests) {
        [_request removeObserver:self forKeyPath:requestFinishedKeyPath];
    }
    [_lastAccessTokenUpdate release];
    [_requests release];
//    _fbDialog.delegate = nil;
//    [_fbDialog release];
    [_appId release];
    [_urlSchemeSuffix release];
//    [_frictionlessRequestSettings release];
    [super dealloc];
}


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)observeFinishedContextValueForKeyPath:(NSString *)keyPath
                                     ofObject:(id)object
                                       change:(NSDictionary *)change {
    FBRequest *_request = (FBRequest *)object;
    FBRequestState requestState = [_request state];
    if (requestState == kFBRequestStateComplete) {
        if ([_request sessionDidExpire]) {
            [self invalidateSession];
            if ([self.sessionDelegate respondsToSelector:@selector(fbSessionInvalidated)]) {
                [self.sessionDelegate fbSessionInvalidated];
            }
        }
        [_request removeObserver:self forKeyPath:requestFinishedKeyPath];
        [_requests removeObject:_request];
    }
    
}
#pragma GCC diagnostic pop

- (void)observeTokenContextValueForKeyPath:(NSString *)keyPath
                                    change:(NSDictionary *)change {
    // here we are forwarding KVO notifications from an inner object
    if ([change objectForKey:NSKeyValueChangeNotificationIsPriorKey]) {
        [self willChangeValueForKey:keyPath];
    } else {
        [self didChangeValueForKey:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // dispatch for various observe cases
    if (context == finishedContext) {
        [self observeFinishedContextValueForKeyPath:keyPath
                                           ofObject:object
                                             change:change];
    } else if (context == tokenContext) {
        [self observeTokenContextValueForKeyPath:keyPath
                                          change:change];
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)invalidateSession {
    [self.session close];
    [self.tokenCaching clearToken];
    
//    [FBUtility deleteFacebookCookies];
    
    // setting to nil also terminates any active request for whitelist
//    [_frictionlessRequestSettings updateRecipientCacheWithRecipients:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//public

/**
 * Starts a dialog which prompts the user to log in to Facebook and grant
 * the requested permissions to the application.
 *
 * If the device supports multitasking, we use fast app switching to show
 * the dialog in the Facebook app or, if the Facebook app isn't installed,
 * in Safari (this enables Facebook Login by allowing multiple apps on
 * the device to share the same user session).
 * When the user grants or denies the permissions, the app that
 * showed the dialog (the Facebook app or Safari) redirects back to
 * the calling application, passing in the URL the access token
 * and/or any other parameters the Facebook backend includes in
 * the result (such as an error code if an error occurs).
 *
 * See http://developers.facebook.com/docs/authentication/ for more details.
 *
 * Also note that requests may be made to the API without calling
 * authorize() first, in which case only public information is returned.
 *
 * @param permissions
 *            A list of permission required for this application: e.g.
 *            "read_stream", "publish_stream", or "offline_access". see
 *            http://developers.facebook.com/docs/authentication/permissions
 *            This parameter should not be null -- if you do not require any
 *            permissions, then pass in an empty String array.
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the user has logged in.
 */
- (void)authorize:(NSArray *)permissions {
    
    // if we already have a session, git rid of it
    [self.session close];
    self.session = nil;
    [self.tokenCaching clearToken];

    self.session = [[[FBSession alloc] initWithAppID:_appId
                                         permissions:permissions
                                     urlSchemeSuffix:_urlSchemeSuffix
                                  tokenCacheStrategy:self.tokenCaching]
                    autorelease];
    
    [self.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        switch (status) {
            case FBSessionStateOpen:
                // call the legacy session delegate
                [self fbDialogLogin:session.accessTokenData.accessToken expirationDate:session.accessTokenData.expirationDate params:nil];
                break;
            case FBSessionStateClosedLoginFailed:
            { // prefer to keep decls near to their use
                // unpack the error code and reason in order to compute cancel bool
                NSString *errorCode = [[error userInfo] objectForKey:FBErrorLoginFailedOriginalErrorCode];
                NSString *errorReason = [[error userInfo] objectForKey:FBErrorLoginFailedReason];
                BOOL userDidCancel = !errorCode && (!errorReason ||
                                                    [errorReason isEqualToString:FBErrorLoginFailedReasonInlineCancelledValue]);

                // call the legacy session delegate
                [self fbDialogNotLogin:userDidCancel];
            }
                break;
                // presently extension, log-out and invalidation are being implemented in the Facebook class
            default:
                break; // so we do nothing in response to those state transitions
        }
    }];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [self.session handleOpenURL:url];
}

- (void)extendAccessToken {
    if (_isExtendingAccessToken) {
        return;
    }
    _isExtendingAccessToken = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"fb_extend_sso_token", @"grant_type",
                                   nil];
    _requestExtendingAccessToken = [self requestWithGraphPath:@"oauth/access_token"
                                                    andParams:params
                                                  andDelegate:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//FBLoginDialogDelegate

/**
 * Set the authToken and expirationDate after login succeed
 */
- (void)fbDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate params:(NSDictionary *)params {
    // Note this legacy flow does not use `params`.
    [_lastAccessTokenUpdate release];
    _lastAccessTokenUpdate = [[NSDate date] retain];
    self.accessToken = token;
    self.expirationDate = expirationDate;
//    [self reloadFrictionlessRecipientCache];
    if ([self.sessionDelegate respondsToSelector:@selector(fbDidLogin)]) {
        [self.sessionDelegate fbDidLogin];
    }
}

/**
 * Did not login call the not login delegate
 */
- (void)fbDialogNotLogin:(BOOL)cancelled {
    if ([self.sessionDelegate respondsToSelector:@selector(fbDidNotLogin:)]) {
        [self.sessionDelegate fbDidNotLogin:cancelled];
    }
}

/**
 * Make a request to the Facebook Graph API with the given string
 * parameters using an HTTP GET (default method).
 *
 * See http://developers.facebook.com/docs/api
 *
 *
 * @param graphPath
 *            Path to resource in the Facebook graph, e.g., to fetch data
 *            about the currently logged authenticated user, provide "me",
 *            which will fetch http://graph.facebook.com/me
 * @param parameters
 *            key-value string parameters, e.g. the path "search" with
 *            parameters "q" : "facebook" would produce a query for the
 *            following graph resource:
 *            https://graph.facebook.com/search?q=facebook
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 * @return FBRequest
 *            Returns a pointer to the FBRequest object.
 */
- (FBRequest *)requestWithGraphPath:(NSString *)graphPath
                          andParams:(NSMutableDictionary *)params
                        andDelegate:(id<SocializeFBRequestDelegate>)delegate {
    
    return [self requestWithGraphPath:graphPath
                            andParams:params
                        andHttpMethod:@"GET"
                          andDelegate:delegate];
}

/**
 * Make a request to the Facebook Graph API with the given
 * HTTP method and string parameters. Note that binary data parameters
 * (e.g. pictures) are not yet supported by this helper function.
 *
 * See http://developers.facebook.com/docs/api
 *
 *
 * @param graphPath
 *            Path to resource in the Facebook graph, e.g., to fetch data
 *            about the currently logged authenticated user, provide "me",
 *            which will fetch http://graph.facebook.com/me
 * @param parameters
 *            key-value string parameters, e.g. the path "search" with
 *            parameters {"q" : "facebook"} would produce a query for the
 *            following graph resource:
 *            https://graph.facebook.com/search?q=facebook
 *            To upload a file, you should specify the httpMethod to be
 *            "POST" and the "params" you passed in should contain a value
 *            of the type (UIImage *) or (NSData *) which contains the
 *            content that you want to upload
 * @param httpMethod
 *            http verb, e.g. "GET", "POST", "DELETE"
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 * @return FBRequest
 *            Returns a pointer to the FBRequest object.
 */
- (FBRequest *)requestWithGraphPath:(NSString *)graphPath
                          andParams:(NSMutableDictionary *)params
                      andHttpMethod:(NSString *)httpMethod
                        andDelegate:(id<SocializeFBRequestDelegate>)delegate {
    [self updateSessionIfTokenUpdated];
    [self extendAccessTokenIfNeeded];
    
    FBRequest *request = [[FBRequest alloc] initWithSession:self.session
                                                  graphPath:graphPath
                                                 parameters:params
                                                 HTTPMethod:httpMethod];
//    [request setDelegate:delegate];
    [request startWithCompletionHandler:nil];
    
    return request;
}

- (void)updateSessionIfTokenUpdated {
    if (self.hasUpdatedAccessToken) {
        self.hasUpdatedAccessToken = NO;
        
        // invalidate current session and create a new one with the same permissions
        NSArray *permissions = self.session.accessTokenData.permissions;
        [self.session close];
        self.session = [[[FBSession alloc] initWithAppID:_appId
                                             permissions:permissions
                                         urlSchemeSuffix:_urlSchemeSuffix
                                      tokenCacheStrategy:self.tokenCaching]
                        autorelease];
        
        // get the session into a valid state
        [self.session openWithCompletionHandler:nil];
    }
}


/**
 * Calls extendAccessToken if shouldExtendAccessToken returns YES.
 */
- (void)extendAccessTokenIfNeeded {
    if ([self shouldExtendAccessToken]) {
        [self extendAccessToken];
    }
}

/**
 * Returns YES if the last time a new token was obtained was over 24 hours ago.
 */
- (BOOL)shouldExtendAccessToken {
    if ([self isSessionValid]) {
        NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        NSDateComponents *components = [calendar components:NSHourCalendarUnit
                                                   fromDate:_lastAccessTokenUpdate
                                                     toDate:[NSDate date]
                                                    options:0];
        
        if (components.hour >= kTokenExtendThreshold) {
            return YES;
        }
    }
    return NO;
}

/**
 * @return boolean - whether this object has an non-expired session token
 */
- (BOOL)isSessionValid {
    return (self.accessToken != nil && self.expirationDate != nil
            && NSOrderedDescending == [self.expirationDate compare:[NSDate date]]);
    
}

@end
