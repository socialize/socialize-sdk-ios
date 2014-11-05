//
//  SocializeFacebookInterface.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeFacebook.h"
#import "ShareProviderProtocol.h"

@interface SocializeFacebookInterface : NSObject <ShareProviderProtocol, SocializeFBSessionDelegate>
@property (nonatomic, retain) SocializeFacebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *handlers;

+ (SocializeFacebookInterface*)sharedFacebookInterface;
- (void)requestWithGraphPath:(NSString*)graphPath
                      params:(NSDictionary*)params
                  httpMethod:(NSString*)httpMethod
                  completion:(void (^)(id result, NSError *error))completion;

@end
