//
//  SZComposeCommentViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZComposeCommentViewController.h"
#import "SZComposeCommentMessageViewController.h"

@interface SZComposeCommentViewController ()
@property (nonatomic, retain) SZComposeCommentMessageViewController *composeCommentViewController;

@end

@implementation SZComposeCommentViewController
@synthesize composeCommentViewController = composeCommentViewController_;

- (void)dealloc {
    self.composeCommentViewController = nil;
    
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        [self pushViewController:self.composeCommentViewController animated:NO];
        self.delegate = self;
    }
    return self;
}

//- (SZComposeCommentMessageViewController*)composeCommentViewController {
//    if (composeCommentViewController_ == nil) {
//        composeCommentViewController_ = [[SZComposeCommentMessageViewController alloc] initWithEntity:nil];
//        composeCommentViewController_.completionBlock = ^(NSString *text, SZCommentOptions options) {
//        };
//    }
//    return composeCommentViewController_;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
