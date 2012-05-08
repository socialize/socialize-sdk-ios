//
//  SocializeDeviceToken.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/12/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeEntity.h"
#import "SocializeUser.h"
#import "SocializeApplication.h"

@protocol SocializeDeviceToken<SocializeObject>

-(NSString * )device_alias;
-(void)setDevice_alias:(NSString *)deviceAlias;


-(NSString * )device_token;
-(void)setDevice_token:(NSString *)deviceToken;

-(id<SocializeUser>)user;
-(void)setUser:(id<SocializeUser>)user;

-(id<SocializeApplication>)application;
-(void)setApplication:(id<SocializeApplication>)application;
@end

@interface SocializeDeviceToken : SocializeObject<SocializeDeviceToken> {
}
@property (nonatomic,retain) NSString *device_alias;
@property (nonatomic,retain) NSString *device_token;
@property (nonatomic,retain) id<SocializeUser> user;
@property (nonatomic,retain) id<SocializeApplication> application;
@end
