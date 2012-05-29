//
//  SZComposeCommentViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZComposeCommentViewController.h"
#import "SZComposeCommentMessageViewController.h"
#import "SZCommentUtils.h"

@interface SZComposeCommentViewController ()
@property (nonatomic, assign) BOOL initialized;

@end

@implementation SZComposeCommentViewController
@synthesize initialized = initialized_;
@synthesize entity = entity_;
@synthesize successBlock = successBlock_;
@synthesize cancellationBlock = cancellationBlock_;

- (void)dealloc {
    self.entity = nil;
    self.successBlock = nil;
    self.cancellationBlock = nil;
    
    [super dealloc];
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.initialized) {
        [SZCommentUtils showCommentComposerWithDisplay:self entity:self.entity success:self.successBlock failure:^(NSError *error) {
            NSLog(@"Failed: %@", [error localizedDescription]);
            BLOCK_CALL(self.cancellationBlock);
        }];
        
        self.initialized = YES;
    }
}
     
- (void)socializeWillBeginDisplaySequenceWithViewController:(UIViewController *)viewController {
    [self pushViewController:viewController animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

@end
