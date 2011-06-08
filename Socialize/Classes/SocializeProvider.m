/*
 * SocializeProvider.m
 * SocializeSDK
 *
 * Created on 6/8/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "SocializeProvider.h"
#import "SocializeRequest.h"

static NSString* kRestserverBaseURL = @"http://api.dev.appmakr.com/method/";
//static NSString* kLogin = @"oauth";
static NSString* kSDK = @"ios";
static NSString* kSDKVersion = @"1";

@implementation SocializeProvider

@synthesize accessToken = _accessToken,
expirationDate = _expirationDate,
sessionDelegate = _sessionDelegate;

/**
 * Initialize the Facebook object with application ID.
 */
- (id)initWithAppId:(NSString *)app_id {
    self = [super init];
    if (self) {
        [_appId release];
        _appId = [app_id copy];
    }
    return self;
}

/**
 * Override NSObject : free the space
 */
- (void)dealloc {
    [_accessToken release];
    [_expirationDate release];
    [_request release];
    [_appId release];
    [_permissions release];
    [super dealloc];
}

/**
 * A private helper function for sending HTTP requests.
 *
 * @param url
 *            url to send http request
 * @param params
 *            parameters to append to the url
 * @param httpMethod
 *            http method @"GET" or @"POST"
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
- (void)openUrl:(NSString *)url
         params:(NSMutableDictionary *)params
     httpMethod:(NSString *)httpMethod
       delegate:(id<SocializeRequestDelegate>)delegate {
    [params setValue:@"json" forKey:@"format"];
    [params setValue:kSDK forKey:@"sdk"];
    [params setValue:kSDKVersion forKey:@"sdk_version"];
    if ([self isSessionValid]) {
        [params setValue:self.accessToken forKey:@"access_token"];
    }
    
    [_request release];
    _request = [[SocializeRequest getRequestWithParams:params
                                            httpMethod:httpMethod
                                              delegate:delegate
                                            requestURL:url] retain];
    [_request connect];
}

/**
 * A private function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//public



/**
 * @param application_id
 *            The Socialize application id, e.g. "350685531728".
 * @param permissions
 *            A list of permission required for this application: e.g.
 *            permissions, then pass in an empty String array.
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the user has logged in.
 */
- (void)authenticate:(NSString *)udid callbackurlString:(NSString*)urlString thidPartyAccessToken:(NSString*)thirdPartyAccessToken  
            delegate:(id<SocializeProviderDelegate>)delegate
{
    
    //  [_permissions release];
    // _permissions = [permissions retain];
    
    _sessionDelegate = delegate;
    //  [self authorizeWithFBAppAuth:YES safariAuth:YES];
}

/**
 * Invalidate the current user session by removing the access token in
 * memory, clearing the browser cookie, and calling auth.expireSession
 * through the API.
 *
 * Note that this method dosen't unauthorize the application --
 * it just invalidates the access token. To unauthorize the application,
 * the user must remove the app in the app settings page under the privacy
 * settings screen on facebook.com.
 *
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the application has logged out
 */
- (void)logout:(id<SocializeProviderDelegate>)delegate {
    
    _sessionDelegate = delegate;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [self requestWithMethodName:@"auth.expireSession"
                      andParams:params andHttpMethod:@"GET"
                    andDelegate:nil];
    
    [params release];
    [_accessToken release];
    _accessToken = nil;
    [_expirationDate release];
    _expirationDate = nil;
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:
                                [NSURL URLWithString:@"http://login.facebook.com"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
    if ([self.sessionDelegate respondsToSelector:@selector(socializeDidLogout)]) {
        [_sessionDelegate socializeDidLogout];
    }
}

/**
 * Make a request to Facebook's REST API with the given
 * parameters. One of the parameter keys must be "method" and its value
 * should be a valid REST server API method.
 *
 * See http://developers.facebook.com/docs/reference/rest/
 *
 * @param parameters
 *            Key-value pairs of parameters to the request. Refer to the
 *            documentation: one of the parameters must be "method".
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
- (void)requestWithParams:(NSMutableDictionary *)params
              andDelegate:(id <SocializeRequestDelegate>)delegate {
    if ([params objectForKey:@"method"] == nil) {
        NSLog(@"API Method must be specified");
        return;
    }
    
    NSString * methodName = [params objectForKey:@"method"];
    [params removeObjectForKey:@"method"];
    
    [self requestWithMethodName:methodName
                      andParams:params
                  andHttpMethod:@"GET"
                    andDelegate:delegate];
}

- (void)requestWithMethodName:(NSString *)methodName
                    andParams:(NSMutableDictionary *)params
                andHttpMethod:(NSString *)httpMethod
                  andDelegate:(id <SocializeRequestDelegate>)delegate {
    NSString * fullURL = [kRestserverBaseURL stringByAppendingString:methodName];
    [self openUrl:fullURL params:params httpMethod:httpMethod delegate:delegate];
}


/**
 * @return boolean - whether this object has an non-expired session token
 */
- (BOOL)isSessionValid {
    return (self.accessToken != nil && self.expirationDate != nil
            && NSOrderedDescending == [self.expirationDate compare:[NSDate date]]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////

//SocializeRequestDelegate

/**
 * Handle the auth.ExpireSession api call failure
 */
- (void)request:(SocializeRequest*)request didFailWithError:(NSError*)error{
    NSLog(@"Failed to expire the session");
}

@end