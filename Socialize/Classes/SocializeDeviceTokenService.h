//
//  SocializeNotificationService.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/7/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeService.h"
#import "NSTimer+BlocksKit.h"

@interface SocializeDeviceTokenService : SocializeService


@property(nonatomic, retain) NSTimer *registerDeviceTimer;
-(void)registerDeviceTokens:(NSArray *) tokens;
-(void)registerDeviceToken:(NSData *)deviceToken;
-(void)registerDeviceTokenString:(NSString *)deviceToken;
-(void)registerDeviceTokensWithTimer:(NSString *)deviceToken;
-(void)registerDeviceToken:(NSString *)deviceToken persistent:(BOOL)isPersistent;
-(NSString *)getDeviceToken;
//invalidate the registertimer, checks for nil values
-(void) invalidateRegisterDeviceTimer;
//determines wether we should register the device token.  based on wether the one in the user defaults
//matches the one passed in.
-(BOOL)shouldRegisterDeviceToken:(NSString *)deviceToken;
@end
