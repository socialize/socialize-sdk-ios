/*
 * SocializeProvider.h
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

#import <Foundation/Foundation.h>
#import "SocializeRequest.h"

extern NSString* const kRestserverBaseURL;

@protocol SocializeObject;


@protocol  SocializeProviderDelegate;
@protocol  SocializeRequestDelegate;
@class     SocializeRequest;

@interface SocializeProvider : NSObject 
{

@private
    NSString            *_accessToken;
    NSDate              *_expirationDate;
    id<SocializeProviderDelegate> _sessionDelegate;
    SocializeRequest*  _request;
}

@property(nonatomic, copy) NSString* accessToken;
@property(nonatomic, copy) NSDate* expirationDate;
@property(nonatomic, assign) id<SocializeProviderDelegate> sessionDelegate;
@property(nonatomic, readonly) SocializeRequest* request;

- (void)authenticate:(NSString *)udid
            delegate:(id<SocializeProviderDelegate>)delegate;

- (void)authenticateWithThirdPartyAccessToken:(NSString*)thirdPartyAccessToken  
                        andExpirationDate:(NSDate*) date
                                 delegate:(id<SocializeProviderDelegate>)delegate;

- (void)requestWithParams:(id)params
              andDelegate:(id <SocializeRequestDelegate>)delegate
       expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat;

- (void)requestWithMethodName:(NSString *)methodName
                    andParams:(id)params
           expectedJSONFormat:(ExpectedResponseFormat)expectedJSONFormat
                andHttpMethod:(NSString *)httpMethod
                  andDelegate:(id <SocializeRequestDelegate>)delegate;

- (BOOL)isSessionValid;

@end
////////////////////////////////////////////////////////////////////////////////

/**
 * Your application should implement this delegate to receive service callbacks.
 */

@protocol SocializeProviderDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in.
 */
- (void)socializeDidAuthentiateAnonymously;
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