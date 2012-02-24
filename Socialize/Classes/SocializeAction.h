//
//  SocializeAction.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeServiceDelegate.h"

@class Socialize;
@class SocializeUIDisplayProxy;

@interface SocializeAction : NSOperation <SocializeServiceDelegate>
- (id)initWithDisplayObject:(id)displayObject
                    display:(id)display
                    success:(void(^)())success
                    failure:(void(^)(NSError *error))failure;

- (void)cancelAllCallbacks;
- (void)executeAction;
- (void)finishedOnMainThread;
- (NSError*)defaultError;
- (void)failWithError:(NSError*)error;
- (void)succeed;

+ (void)executeAction:(SocializeAction*)action;
+ (NSOperationQueue*)actionQueue;

@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) SocializeUIDisplayProxy *displayProxy;
@property (nonatomic, copy) void (^failureBlock)(NSError *error);
@property (nonatomic, copy) void (^successBlock)();

@end
