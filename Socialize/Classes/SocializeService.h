//
//  SocializeService.h
//  SocializeSDK
//
//  Created by William Johnson on 5/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocializeObject;


@protocol  SocializeServiceDelegate;
@protocol  SocializeRequestDelegate;
@class     SocializeRequest;

@interface SocializeService : NSObject 
{
    NSString            *_accessToken;
    NSDate              *_expirationDate;
    id<SocializeServiceDelegate> _sessionDelegate;
    SocializeRequest*  _request;
    NSString*          _appId;
    NSArray*           _permissions;
}

@property(nonatomic, copy) NSString* accessToken;
@property(nonatomic, copy) NSDate* expirationDate;
@property(nonatomic, assign) id<SocializeServiceDelegate> sessionDelegate;

- (id)initWithAppId:(NSString *)app_id;


- (void)authenticate:(NSString *)udid callbackurlString:(NSString*)urlString thidPartyAccessToken:      (NSString*)thirdPartyAccessToken  
            delegate:(id<SocializeServiceDelegate>)delegate;


- (void)logout:(id<SocializeServiceDelegate>)delegate;

- (void)requestWithParams:(NSMutableDictionary *)params
              andDelegate:(id <SocializeRequestDelegate>)delegate;

- (void)requestWithMethodName:(NSString *)methodName
                    andParams:(NSMutableDictionary *)params
                andHttpMethod:(NSString *)httpMethod
                  andDelegate:(id <SocializeRequestDelegate>)delegate;

- (BOOL)isSessionValid;

@end
////////////////////////////////////////////////////////////////////////////////

/**
 * Your application should implement this delegate to receive service callbacks.
 */

@protocol SocializeServiceDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in.
 */
- (void)socializeDidAuthentiateAnonmously;
- (void)socializeDidAuthentiateWithThirdPartyInfo;

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)socializeDidNotLogin:(BOOL)cancelled;

/**
 * Called when the user logged out.
 */
- (void)socializeDidLogout;


@end
