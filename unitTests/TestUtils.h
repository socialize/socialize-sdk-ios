//
//  TestUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/9/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCMockRecorder (TestUtils)
- (id)andReturnBool:(BOOL)b;
- (id)andReturnInteger:(NSInteger)i;
- (id)andReturnUInteger:(NSUInteger)i;
@end

@interface OCMockObject (TestUtils)
- (void)stubIsKindOfClass:(Class)class;
- (void)stubIsMemberOfClass:(Class)class;

@end

@interface UIButton (TestUtils)
- (void)simulateControlEvent:(UIControlEvents)event;
@end

void RunOnMainThread(void (^block)());
