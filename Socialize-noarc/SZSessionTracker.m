//
//  SZSessionTracker.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/25/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZSessionTracker.h"
#import "NSString+UUID.h"
#import "socialize_globals.h"
#import "_Socialize.h"
#import "SZEventUtils.h"

#define SESSION_BUCKET @"SESSION"
#define SESSION_BEGIN_ACTION @"begin"
#define SESSION_END_ACTION @"end"

static SZSessionTracker *sharedSessionTracker;

@interface SZSessionTracker ()
@property (nonatomic, copy) NSString *currentSessionIdentifier;
@end

@implementation SZSessionTracker
@synthesize  currentSessionIdentifier = _currentSessionIdentifier;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

+ (void)load {
    (void)[self sharedSessionTracker];
}

+ (SZSessionTracker*)sharedSessionTracker {
    if (sharedSessionTracker == nil) {
        sharedSessionTracker = [[SZSessionTracker alloc] init];
    }
    
    return sharedSessionTracker;
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    return self;
}

- (void)resetSessionIndentifier {
    self.currentSessionIdentifier = [NSString stringWithUUID];
}

- (void)trackSessionChangeWithAction:(NSString*)action {
    NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.currentSessionIdentifier, @"session_id",
                            action, @"action",
                            nil];
    
    [SZEventUtils trackEventWithBucket:SESSION_BUCKET values:values success:nil failure:nil];
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    [self resetSessionIndentifier];

    [self trackSessionChangeWithAction:SESSION_BEGIN_ACTION];
}

- (void)applicationWillResignActive:(NSNotification*)notification {
    [self trackSessionChangeWithAction:SESSION_END_ACTION];
}

@end
