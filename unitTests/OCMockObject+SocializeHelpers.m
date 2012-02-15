//
//  OCMockObject+SocializeHelpers.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "OCMockObject+SocializeHelpers.h"

@interface OCMockObject ()
+ (id)_makeNice:(OCMockObject *)mock;
@end

@implementation OCMockObject (SocializeHelpers)

- (id)makeNice {
    [OCMockObject _makeNice:self];
    return self;
}

@end
