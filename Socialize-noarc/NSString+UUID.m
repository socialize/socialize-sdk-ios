//
//  NSString+UUID.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/25/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString*)stringWithUUID {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    return uuidString;
}

@end
