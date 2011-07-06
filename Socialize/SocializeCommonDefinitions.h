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

#define kFACEBOOK_ACCESS_TOKEN_KEY @"FBAccessTokenKey"
#define kFACEBOOK_EXPIRATION_DATE_KEY @"FBExpirationDateKey"

typedef enum {
    FacebookAuth
} ThirdPartyAuthName;

@protocol SocializeAuthenticationDelegate
-(void)didAuthenticate;
-(void)didNotAuthenticate:(NSError*)error;
@end

@protocol SocializeLikeServiceDelegate <NSObject>

-(void)didFailService:(id)service error:(NSError*)error;
-(void)didPostLike:(id)service like:(id)data;
-(void)didDeleteLike:(id)service like:(id)data;
-(void)didFetchLike:(id)service like:(id)data;

@end

@class SocializeCommentsService;
@protocol SocializeComment;

@protocol SocializeCommentsServiceDelegate <NSObject>
@required
-(void) receivedComment: (SocializeCommentsService*)service comment: (id<SocializeComment>) comment;
-(void) receivedComments: (SocializeCommentsService*)service comments: (NSArray*) comments;
-(void) didFailService:(SocializeCommentsService*)service withError: (NSError *)error;
@end


@class SocializeViewService;
@protocol SocializeView;
@protocol SocializeViewServiceDelegate

-(void) viewService:(SocializeViewService *)viewService didReceiveView:(id<SocializeView>)viewObject;
-(void) viewService:(SocializeViewService *)viewService didReceiveListOfViews:(NSArray *)viewList;
-(void) viewService:(SocializeViewService *)viewService didFailWithError:(NSError *)error;

@end


@class SocializeShareService;
@protocol SocializeShare;
@protocol SocializeShareServiceDelegate

-(void) shareService:(SocializeShareService *)shareService didReceiveShare:(id<SocializeShare>)shareObject;
-(void) shareService:(SocializeShareService *)shareService didReceiveListOfShare:(NSArray *)shareList;
-(void) shareService:(SocializeShareService *)shareService didFailWithError:(NSError *)error;

@end
