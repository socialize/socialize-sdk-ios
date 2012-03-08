//
//  NSObject+ClassMock.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/6/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassMockForwarder : NSProxy
+ (void)stopMockingAllClasses;
@end

@interface NSObject (ClassMock)
+ (id)expect;
+ (void)verify;
+ (id)stub;
+ (void)startMockingClassWithClassMock:(id)classMock;
+ (void)startMockingClass;
+ (void)stopMockingClass;
+ (void)stopMockingClassAndVerify;
+ (Class)origClass;
+ (id)classMock;

@end
