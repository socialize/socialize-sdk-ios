//
//  NSMutableArray+Socialize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Socialize)
- (void)removeObjectsAfterIndex:(NSUInteger)index;
- (void)removeObjectsAfterObject:(id)object;

@end
