//
//  TestUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "TestUtils.h"
#import <objc/runtime.h>

@implementation OCMockRecorder (TestUtils)
- (id)andReturnBool:(BOOL)b {
    return [self andReturnValue:OCMOCK_VALUE(b)];
}

- (id)andReturnUInteger:(NSUInteger)i {
    return [self andReturnValue:OCMOCK_VALUE(i)];
}

- (id)andReturnInteger:(NSInteger)i {
    return [self andReturnValue:OCMOCK_VALUE(i)];
}

- (id)andDo0:(void(^)())action {
    return [self andDo:^(NSInvocation *inv) {
        action();
    }];
}

- (id)andDo1:(void(^)(id))action {
    return [self andDo:^(NSInvocation *inv) {
        id arg1;
        [inv getArgument:&arg1 atIndex:2];
        action(arg1);
    }];
}

- (id)andDo2:(void(^)(id, id))action {
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        action(arg1, arg2);
    }];
}

- (id)andDo3:(void(^)(id, id, id))action {
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2, arg3;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        [inv getArgument:&arg3 atIndex:4];
        action(arg1, arg2, arg3);
    }];
}

- (id)andDo4:(void(^)(id, id, id, id))action {
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2, arg3, arg4;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        [inv getArgument:&arg3 atIndex:4];
        [inv getArgument:&arg4 atIndex:5];
        action(arg1, arg2, arg3, arg4);
    }];
}

- (id)andDo5:(void(^)(id, id, id, id, id))action {
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2, arg3, arg4, arg5;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        [inv getArgument:&arg3 atIndex:4];
        [inv getArgument:&arg4 atIndex:5];
        [inv getArgument:&arg5 atIndex:6];
        action(arg1, arg2, arg3, arg4, arg5);
    }];
}

- (id)andReturnFromBlock:(id (^)())block {
    return [self andDo:^(NSInvocation *inv) {
        id retVal = block();
        [inv setReturnValue:&retVal];
    }];
}

- (id)andReturnBoolFromBlock:(BOOL (^)())block {
    return [self andDo:^(NSInvocation *inv) {
        BOOL retVal = block();
        [inv setReturnValue:&retVal];
    }];
}

@end

@interface OCMockObject ()
+ (id)_makeNice:(OCMockObject *)mock;
@end


@implementation OCMockObject (TestUtils)

+ (id)classMockForClass:(Class)class {
    Class meta = object_getClass(class);
    return [self mockForClass:meta];
}

- (id)makeNice {
    [OCMockObject _makeNice:self];
    return self;
}

- (void)stubIsKindOfClass:(Class)class {
    [[[self stub] andReturnBool:YES] isKindOfClass:class];
    [[[self stub] andReturnBool:NO] isKindOfClass:OCMOCK_ANY];
}

- (void)stubIsMemberOfClass:(Class)class {
    [[[self stub] andReturnBool:YES] isMemberOfClass:class];
    [[[self stub] andReturnBool:NO] isMemberOfClass:OCMOCK_ANY];
}

- (void)expectAllocAndReturn:(id)instance {
    [[[[self stub] andDo0:^{
        [instance retain];
    }] andReturn:instance] alloc];
}

@end

@implementation UIControl (TestUtils)
- (void)simulateControlEvent:(UIControlEvents)event {
    for (id target in [self allTargets]) {
        NSArray *actions = [self actionsForTarget:target forControlEvent:event];
        for (NSString *selName in actions) {
            SEL sel = NSSelectorFromString(selName);
            [target performSelector:sel withObject:self];
        }
    }

}
@end
void RunOnMainThread(void (^blk)()) {
    if ([NSThread isMainThread]) {
        NSLog(@"Running block directly");
        blk();
    } else {
        NSLog(@"Adding block to queue");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"Running block on queue");
            blk();
        });
    }
}

@implementation UIActionSheet (TestUtils)
- (void)simulateButtonPressAtIndex:(int)index {
    [self _buttonClicked:[self buttonAtIndex:index]];

}
@end

@implementation UIAlertView (TestUtils)
- (void)simulateButtonPressAtIndex:(int)index {
    [self _buttonClicked:[self buttonAtIndex:index]];

}
@end


