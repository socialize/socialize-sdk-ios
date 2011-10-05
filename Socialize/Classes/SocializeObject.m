//
//  SocializeObject.m
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeObject.h"


@implementation SocializeObject

@synthesize objectID = _objectID;

- (id)copyWithZone:(NSZone *)zone {
    SocializeObject *copy = [[self class] allocWithZone:zone];
    copy.objectID = self.objectID;
    return copy;
}

@end
