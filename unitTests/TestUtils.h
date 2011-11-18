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
@end


void RunOnMainThread(void (^block)());
