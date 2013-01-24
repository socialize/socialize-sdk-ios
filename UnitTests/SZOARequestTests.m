//
//  SZOARequestTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/13/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOARequestTests.h"

@implementation SZOARequestTests
@synthesize request = _request;

- (void)setUp {
}

- (void)tearDown {
    self.request = nil;
}

- (void)testInit {
    NSString *method = @"GET";
    NSString *scheme = @"http";
    NSString *host = @"http://www.getsocialize.com";
    NSString *path = @"/path";
    self.request = [[[SZOARequest alloc] initWithConsumerKey:nil consumerSecret:nil token:nil tokenSecret:nil method:method scheme:scheme host:host path:path parameters:nil multipart:NO success:nil failure:nil] autorelease];
}

@end
