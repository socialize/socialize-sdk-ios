//
//  SocializeAction.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeServiceDelegate.h"
#import "SocializeOptions.h"

@class Socialize;
@class SocializeUIDisplayProxy;
@protocol SocializeUIDisplay;

@interface SocializeAction : NSOperation <SocializeServiceDelegate>

- (id)initWithOptions:(SocializeOptions*)options
         displayProxy:(SocializeUIDisplayProxy*)displayProxy
              display:(id<SocializeUIDisplay>)display;

- (id)initWithOptions:(SocializeOptions*)options
         displayProxy:(SocializeUIDisplayProxy*)displayProxy;

- (id)initWithOptions:(SocializeOptions*)options 
              display:(id<SocializeUIDisplay>)display;

- (void)cancelAllCallbacks;
- (void)executeAction;
- (void)finishedOnMainThread;
- (NSError*)defaultError;
- (void)failWithError:(NSError*)error;
- (void)succeed;

+ (void)executeAction:(SocializeAction*)action;
+ (NSOperationQueue*)actionQueue;
- (void)callSuccessBlock;

@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) SocializeUIDisplayProxy *displayProxy;
@property (nonatomic, copy) void (^failureBlock)(NSError *error);
@property (nonatomic, copy) void (^successBlock)();
@property (nonatomic, retain) SocializeOptions *options;

@end
