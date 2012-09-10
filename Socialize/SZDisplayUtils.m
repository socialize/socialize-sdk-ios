//
//  SZDisplayUtils.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/10/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZDisplayUtils.h"
#import "SZNotificationHandler.h"

static id<SZDisplay>(^globalDisplayBlock)();

@implementation SZDisplayUtils

+ (id<SZDisplay>)globalDisplay {
    if (globalDisplayBlock != nil) {
        return globalDisplayBlock();
    }
    
    return nil;
}

+ (void)setGlobalDisplayBlock:(id<SZDisplay>(^)())displayBlock {
    [[SZNotificationHandler sharedNotificationHandler] setDisplayBlock:displayBlock];
    globalDisplayBlock = displayBlock;
}

@end
