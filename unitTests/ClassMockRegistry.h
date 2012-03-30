//
//  ClassMockRegistry.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/30/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassMockRegistry : NSObject
+ (void)stopMockingAllClasses;

+ (void)registerClassMock:(id)classMock forClass:(Class)class;

+ (void)unregisterClassMockForClass:(Class)class;

+ (NSMutableDictionary*)classMocks;
+ (NSMutableDictionary*)copiedClasses;
+ (id)keyForClassAtAddress:(void*)classAddress;
+ (id)classMockForClass:(Class)class;
+ (Class)copiedClassForClass:(Class)class;

@end
