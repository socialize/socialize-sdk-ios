//
//  SocializeService+Testing.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeService+Testing.h"

@implementation SocializeService (Testing)

- (id)nonRetainingMock {
    id mock = [OCMockObject partialMockForObject:self];
    [[mock stub] retainDelegate];
    [[mock stub] freeDelegate];
    
    return mock;
}

@end
