//
//  SocializeFacebookInterface.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SocializeFBRequest.h"

@class SocializeFacebook;

@interface SocializeFacebookInterface : NSObject <SocializeFBRequestDelegate>
@property (nonatomic, retain) SocializeFacebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *handlers;

- (void)requestWithGraphPath:(NSString*)graphPath params:(NSDictionary*)params httpMethod:(NSString*)httpMethod completion:(void (^)(id result, NSError *error))completion;

@end
