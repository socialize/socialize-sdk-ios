//
//  SocializeCommonDefinitions.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/15/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeUser.h"

#define kSOCIALIZE_USERID_KEY        @"SOCIALIZE_USER_ID"
#define kSOCIALIZE_USERNAME_KEY      @"SOCIALIZE_USER_NAME"
#define kSOCIALIZE_USERIMAGEURI_KEY  @"SOCIALIZE_USER_IMAGE_URI"

#define kSOCIALIZE_TOKEN_KEY         @"SOCIALIZE_TOKEN"

#define kSOCIALIZE_API_KEY      @"98e76bb9-c707-45a4-acf2-029cca3bf216"         
#define kSOCIALIZE_API_SECRET   @"b7364905-cdc6-46d3-85ad-06516b128819"

#define kPROVIDER_NAME          @"SOCIALIZE"
#define kPROVIDER_PREFIX        @"AUTH"


typedef enum {
    FacebookAuth
} ThirdPartyAuthName;

@protocol SocializeAuthenticationDelegate
-(void)didAuthenticate;
-(void)didNotAuthenticate:(NSError*)error;
@end


@protocol SocializeLikeDelegate
-(void)didLikeEntity;
-(void)didUnlikeEntity;
@end
