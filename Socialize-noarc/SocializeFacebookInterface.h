//
//  SocializeFacebookInterface.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShareProviderProtocol.h"
#import <Facebook-iOS-SDK/FacebookSDK/Facebook.h>

@interface SocializeFacebookInterface : NSObject <ShareProviderProtocol, FBSessionDelegate>
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *handlers;

+ (SocializeFacebookInterface*)sharedFacebookInterface;
- (void)requestWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params httpMethod:(NSString*)httpMethod completion:(void (^)(id result, NSError *error))completion;

@end
