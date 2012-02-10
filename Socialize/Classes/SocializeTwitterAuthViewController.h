//
//  SocializeTwitterAuthViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeBaseViewController.h"
#import "SocializeTwitterAuthViewControllerDelegate.h"

@class OAAsynchronousDataFetcher;
@class OAToken;

extern NSString *const SocializeTwitterRequestTokenURL;
extern NSString *const SocializeTwitterAccessTokenURL;
extern NSString *const SocializeTwitterAuthenticateURL;
extern NSString *const SocializeTwitterAuthCallbackScheme;

@interface SocializeTwitterAuthViewController : SocializeBaseViewController <UIWebViewDelegate>
@property (nonatomic, assign) id<SocializeTwitterAuthViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *consumerKey;
@property (nonatomic, copy) NSString *consumerSecret;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) OAToken *requestToken;
@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, retain) OAAsynchronousDataFetcher *dataFetcher;
@property (nonatomic, copy) NSString *verifier;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *userID;
@end
