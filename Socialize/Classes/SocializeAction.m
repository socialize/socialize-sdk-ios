//
//  SocializeAction.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeAction.h"
#import "SocializeUIDisplayProxy.h"
#import "_Socialize.h"
#import "SocializePreprocessorUtilities.h"

@class SocializeFacebookAuthenticator;
@class SocializeTwitterAuthenticator;

static NSOperationQueue *actionQueue;

@interface SocializeAction ()
@property (nonatomic, retain) NSConditionLock *finishedLock;
- (void)waitUntilFinishedOnMainThread;
@end

typedef enum {
    SocializeActionConditionUnfinished,
    SocializeActionConditionFinished
} SocializeActionCondition;

@implementation SocializeAction
@synthesize socialize = socialize_;
@synthesize displayProxy = display_;
@synthesize finishedLock = finishedLock_;
@synthesize failureBlock = failureBlock_;
@synthesize successBlock = successBlock_;
@synthesize options = options_;

- (void)dealloc {
    [socialize_ setDelegate:nil];
    self.socialize = nil;
    self.displayProxy = nil;
    self.finishedLock = nil;
    self.failureBlock = nil;
    self.successBlock = nil;
    self.options = nil;
    
    [super dealloc];
}

- (id)initWithOptions:(SocializeOptions*)options
         displayProxy:(SocializeUIDisplayProxy*)displayProxy
              display:(id<SocializeUIDisplay>)display {
    
    if (self = [super init]) {
        if (displayProxy == nil) {
            displayProxy = [SocializeUIDisplayProxy UIDisplayProxyWithObject:self display:display];
        }
        self.displayProxy = displayProxy;
        self.options = options;
    }
    return self;
}

- (id)initWithOptions:(SocializeOptions*)options
         displayProxy:(SocializeUIDisplayProxy*)displayProxy {
    return [self initWithOptions:options displayProxy:displayProxy display:nil];
}

- (id)initWithOptions:(SocializeOptions*)options 
              display:(id<SocializeUIDisplay>)display {
    return [self initWithOptions:options displayProxy:nil display:display];
}

+ (NSOperationQueue*)actionQueue {
    if (actionQueue == nil) {
        actionQueue = [[NSOperationQueue alloc] init];
    }
    
    return actionQueue;
}

+ (void)executeAction:(SocializeAction*)action {
    [[self actionQueue] addOperation:action];
}

- (NSConditionLock*)finishedLock {
    if (finishedLock_ == nil) {
        finishedLock_ = [[NSConditionLock alloc] initWithCondition:SocializeActionConditionUnfinished];
    }
    return finishedLock_;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    return socialize_;
}

- (NSError*)defaultError {
    NSAssert(NO, @"not implemented");
    return nil;
}

- (void)failWithError:(NSError*)error {
    if (error == nil) {
        error = [self defaultError];
    }
    
    [self.displayProxy stopLoading];
    
    if (self.failureBlock != nil) {
        self.failureBlock(error);
    }
    
    [self finishedOnMainThread];
}

- (void)callSuccessBlock {
    if (self.successBlock != nil) {
        self.successBlock();
    }
}

- (void)succeed {
    [self.displayProxy stopLoading];
    
    [self callSuccessBlock];
    
    [self finishedOnMainThread];
}

- (void)finishedOnMainThread {
    NSAssert([[NSThread currentThread] isMainThread], @"Action must be finished on main thread");
    [self.finishedLock lock];
    [self.finishedLock unlockWithCondition:SocializeActionConditionFinished];
}

- (void)executeAction {
    [self finishedOnMainThread];
}

- (void)main {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Begin the action on the main thread. All actions /must/ end with a call to [self finish]
        [self executeAction];
    });
    
    // Await task completion ([self finishedOnMainThread])
    [self waitUntilFinishedOnMainThread];
    NSLog(@"Action complete");
}

- (void)waitUntilFinishedOnMainThread {
    NSAssert(![[NSThread currentThread] isMainThread], @"Can not wait for action on main thread");
    [self.finishedLock lockWhenCondition:SocializeActionConditionFinished];
    [self.finishedLock unlock];
}

- (void)cancelAllCallbacks {
    [socialize_ setDelegate:nil];
}

@end
