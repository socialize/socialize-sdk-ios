//
//  SZDisplayUtils.h
//  Socialize
//
//  Created by Nathaniel Griswold on 9/10/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZDisplay.h"

@interface SZDisplayUtils : NSObject
+ (void)setGlobalDisplayBlock:(id<SZDisplay>(^)())displayBlock;
+ (id<SZDisplay>)globalDisplay;

@end
