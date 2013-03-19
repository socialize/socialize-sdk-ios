//
//  SocializeDeviceTokenSender.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeServiceDelegate.h"

@class Socialize;

@interface SocializeDeviceTokenSender : NSObject <SocializeServiceDelegate>
+ (SocializeDeviceTokenSender*)sharedDeviceTokenSender;
+ (void)disableSender;

/** Register token with server */
- (void)registerDeviceToken:(NSData*)deviceToken development:(BOOL)development;

/* The app developer has made us aware of their push token */
- (BOOL)tokenAvailable;

/* The push token has made it to the server */
- (BOOL)tokenOnServer;

// FIXME actual api client wrapper should be separated from front-facing 'Socialize' component
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign, readonly) BOOL tokenOnServer;
@property (nonatomic, assign, readonly) BOOL tokenIsDevelopment;

@end
