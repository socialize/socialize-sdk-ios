//
//  TestUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMock/OCMock.h"

@interface OCMockRecorder (TestUtils)
- (id)andReturnBool:(BOOL)b;
- (id)andReturnInteger:(NSInteger)i;
- (id)andReturnUInteger:(NSUInteger)i;

- (id)andDo0:(void(^)())action;
- (id)andDo1:(void(^)(id))action;
- (id)andDo2:(void(^)(id, id))action;
- (id)andDo3:(void(^)(id, id, id))action;
- (id)andDo4:(void(^)(id, id, id, id))action;
- (id)andDo5:(void(^)(id, id, id, id, id))action;

- (id)andReturnFromBlock:(id (^)())block;
- (id)andReturnBoolFromBlock:(BOOL (^)())block;
@end

// Expose the realObject private method
@interface OCMockObject ()
- (id)realObject;
@end

@interface OCMockObject (TestUtils)
+ (id)classMockForClass:(Class)class;
- (void)stubIsKindOfClass:(Class)class;
- (void)stubIsMemberOfClass:(Class)class;
- (id)makeNice;
- (void)expectAllocAndReturn:(id)instance;
@end

@interface UIControl (TestUtils)
- (void)simulateControlEvent:(UIControlEvents)event;
@end

@interface UIActionSheet ()
-(id)buttonAtIndex:(int)index;
-(void)_buttonClicked:(id)clicked;
@end

@interface UIActionSheet (TestUtils)
- (void)simulateButtonPressAtIndex:(int)index;

@end

@interface UIAlertView ()
-(id)buttonAtIndex:(int)index;
-(void)_buttonClicked:(id)clicked;
@end

@interface UIAlertView (TestUtils)
- (void)simulateButtonPressAtIndex:(int)index;
@end

void RunOnMainThread(void (^block)());
