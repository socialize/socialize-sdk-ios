//
//  UIDevice+VersionCheck.m
//  Socialize
//
//  Created by David Jedeikin on 1/5/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "UIDevice+VersionCheck.h"

@implementation UIDevice (VersionCheck)

- (NSUInteger)systemMajorVersion {
    NSString *versionString;
    
    versionString = [self systemVersion];
    return (NSUInteger)[versionString doubleValue];
}
@end
