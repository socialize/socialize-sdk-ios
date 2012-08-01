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
@synthesize fromServer = _fromServer;
@synthesize serverDictionary = _serverDictionary;
@synthesize extraParams = _extraParams;

- (void)dealloc {
    [_serverDictionary release];
    [_extraParams release];
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    SocializeObject *copy = [[self class] allocWithZone:zone];
    copy.objectID = self.objectID;
    return copy;
}

@end
