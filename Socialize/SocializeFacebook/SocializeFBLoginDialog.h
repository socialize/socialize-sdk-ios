/***
 Symbols renamed to avoid collision in third party developers projects which might have an older version or a version of facebook SDK which might not work with Socialize SDK 
 */

/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#import "SocializeFBDialog.h"

@protocol SocializeFBLoginDialogDelegate;

/**
 * Do not use this interface directly, instead, use authorize in Facebook.h
 *
 * Facebook Login Dialog interface for start the facebook webView login dialog.
 * It start pop-ups prompting for credentials and permissions.
 */

@interface SocializeFBLoginDialog : SocializeFBDialog {
  id<SocializeFBLoginDialogDelegate> _loginDelegate;
}

-(id) initWithURL:(NSString *) loginURL
      loginParams:(NSMutableDictionary *) params
      delegate:(id <SocializeFBLoginDialogDelegate>) delegate;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol SocializeFBLoginDialogDelegate <NSObject>

- (void)fbDialogLogin:(NSString*)token expirationDate:(NSDate*)expirationDate;

- (void)fbDialogNotLogin:(BOOL)cancelled;

@end


