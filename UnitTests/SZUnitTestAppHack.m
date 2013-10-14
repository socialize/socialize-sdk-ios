//
//  SZUnitTestAppHack.m
//  Socialize
//
//  Created by Nate Griswold on 3/11/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//
// https://github.com/gabriel/gh-unit/issues/96#issuecomment-11598028

#import "SZUnitTestAppHack.h"
#import <GHUnitIOS/GHUnit.h>
#import <Socialize/Socialize.h>

static NSString *delegateClassName;
extern void __gcov_flush(void);

@implementation SZUnitTestAppHack

+ (void)setDelegateClassName:(NSString*)className {
    delegateClassName = className;
}

+ (NSString*)delegateClassName {
    return delegateClassName;
}

- (id)init {
    if ((self = [super init])) {
        if (getenv("GHUNIT_CLI") && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0) {
            
            // Looks like the app delegate doesn't get init'd until after this method, so do it manually.
            if ([[[self class] delegateClassName] length] > 0) {
                Class class = NSClassFromString([[self class] delegateClassName]);
                self.delegate = [[class alloc] init];
                
                if ([self.delegate respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
                    [self.delegate application:self didFinishLaunchingWithOptions:nil];
                }
            }
            
            __block BOOL done = NO;
            NSOperationQueue *queue = [[NSOperationQueue alloc ] init];
            [queue addOperationWithBlock:^{
                NSInteger status = [GHTestRunner run];
                if (status != 0) {
                    NSString *reason = [NSString stringWithFormat:@"Failed to test with status: %d", status];
                    @throw [NSException exceptionWithName:@"TestFailure" reason:reason userInfo:nil];
                }
                __gcov_flush();
                done = YES;
            }];
            
            while(!done) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
            }
        }
    }
    return self;
}

@end
