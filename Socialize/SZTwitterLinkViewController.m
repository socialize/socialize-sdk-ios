//
//  SZTwitterLinkViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/20/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZTwitterLinkViewController.h"
#import "_SZTwitterLinkViewController.h"

@interface SZTwitterLinkViewController ()
@property (nonatomic, strong) _SZTwitterLinkViewController *twitterLink;
@end

@implementation SZTwitterLinkViewController
@synthesize twitterLink = twitterLink_;
@dynamic completionBlock;
@dynamic cancellationBlock;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithConsumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret {
    if (self = [super init]) {
        self.twitterLink = [[_SZTwitterLinkViewController alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];
        [self pushViewController:self.twitterLink animated:NO];
    }
    
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.twitterLink;
}

@end
