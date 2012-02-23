//
//  Socializeobject.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/22/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeUIDisplay.h"

@implementation SocializeUIDisplay
@synthesize displayHandler = displayHandler_;

+ (id)UIDisplayWithDisplayHandler:(id)displayHandler {
    return [[[self alloc] initWithDisplayHandler:displayHandler] autorelease];
}

- (id)initWithDisplayHandler:(id)displayHandler {
    if (self = [super init]) {
        self.displayHandler = displayHandler;
    }
    return self;
}

- (void)displayController:(UIViewController*)controller {
    if ([self.displayHandler respondsToSelector:@selector(object:requiresDisplayOfViewController:)]) {
        [self.displayHandler object:self requiresDisplayOfViewController:controller];
    } else if ([self.displayHandler respondsToSelector:@selector(presentModalViewController:animated:)]) {
        [self.displayHandler presentModalViewController:controller animated:YES];
    } else {
        NSAssert(NO, @"displayHandler must respond to either object:requiresDisplayOfViewController or presentModalViewController:animated");
    }
}

- (void)dismissController:(UIViewController*)controller {
    if ([self.displayHandler respondsToSelector:@selector(object:requiresDismissOfViewController:)]) {
        [self.displayHandler object:self requiresDismissOfViewController:controller];
    } else if ([self.displayHandler respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [self.displayHandler dismissModalViewControllerAnimated:YES];
    } else {
        NSAssert(NO, @"displayHandler must respond to either object:requiresDismissOfViewController or presentModalViewController:animated");
    }
}

- (void)displayActionSheet:(UIActionSheet*)actionSheet {
    if ([self.displayHandler respondsToSelector:@selector(object:requiresDisplayOfActionSheet:)]) {
        [self.displayHandler object:self requiresDisplayOfActionSheet:actionSheet];
    } else if ([self.displayHandler respondsToSelector:@selector(view)]) {
        UIView *view = [self.displayHandler view];
        NSAssert([view isKindOfClass:[UIView class]], @"displayHandler view is not a UIView. Please implement object:requiresDisplayOfobjectSheet");
    } else {
        NSAssert(NO, @"displayHandler must either respond to object:requiresDisplayOfobjectSheet or respond to `view` with a UIView");
    }
}

@end
