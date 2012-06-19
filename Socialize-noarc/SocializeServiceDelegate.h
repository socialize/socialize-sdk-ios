//
//  SocializeServiceDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"
#import "SocializeUser.h"

@class SocializeService;

/**
 This protocol is used as a callback delegate for all socialize services.
 @warning *Note:* Should be implemented by user.
 */
@protocol SocializeServiceDelegate <NSObject>

@optional
/**@name Delete callback*/

/**
 It is called from Socialize service after success DELETE request.
 
 Typical this callback is called after delete like for entity request.
 @param service <Socialize> service which performed operation.
 @param object Should be nil.
 */
-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object;

/**@name Update callback*/

/**
 It is called from Socialize service after success PUT request.
 
 Typical this callback is called after changes in user profile.
 @param service <Socialize> service which performed operation.
 @param object Represented updated <SocializeObject>
 */
-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object;

/**@name Fail callback*/

/**
 It is called in case of any errors of socialize services.
 @param service <Socialize> service which performed operation.
 @param error Error description.
 */
-(void)service:(SocializeService*)service didFail:(NSError*)error;

/**@name Create callback*/

/**
 Creating multiple likes or comments would invoke this callback.
 @param service <Socialize> service which performed operation.
 @param object Successfully created <SocializeObject>.
 @warning *Note:* User should convert object to expected protocol type. For example <SocializeComment> or <SocializeLike>
 */
-(void)service:(SocializeService*)service didCreate:(id)objectOrObjects;

/**@name Fetch callback*/

/**
 Getting/retrieving comments or likes would invoke this callback
 @param service <Socialize> service which performed operation. 
 @param dataArray Array of objects. Every object responds to the <SocializeObject> protocol.
 @warning *Note:* User should convert object to expected protocol type. For example <SocializeComment> or <SocializeLike>
 */
-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray;

/**@name Authentication callback*/

/**
 It is called after success authentication.
 @param user Object of <SocializeUser> protocol.
 */
-(void)didAuthenticate:(id<SocializeUser>)user;
@end
