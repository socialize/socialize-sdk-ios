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



#define kSOCIALIZE_API_KEY_KEY     @"SOCIALIZE_API_KEY"
#define kSOCIALIZE_API_SECRET_KEY  @"SOCIALIZE_API_SECRET"
//#define kSOCIALIZE_API_KEY      @"5f461d4b-999c-430d-a2b2-2df35ff3a9ba"    // stage     
//#define kSOCIALIZE_API_SECRET   @"90aa0fb5-1995-4771-9ed9-f3c4479a9aaa"    // stage


#define kPROVIDER_NAME          @"SOCIALIZE"
#define kPROVIDER_PREFIX        @"AUTH"

#define kFACEBOOK_ACCESS_TOKEN_KEY @"FBAccessTokenKey"
#define kFACEBOOK_EXPIRATION_DATE_KEY @"FBExpirationDateKey"

typedef enum {
    FacebookAuth = 1
} ThirdPartyAuthName;

@protocol SocializeAuthenticationDelegate
    -(void)didAuthenticate;
    -(void)didNotAuthenticate:(NSError*)error;
@end