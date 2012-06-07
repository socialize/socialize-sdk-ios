//
//  SZComposeCommentViewControllerDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeComposeMessageViewController.h"
#import "SocializeBaseViewControllerDelegate.h"

@class SZComposeCommentMessageViewController;

@protocol SZComposeCommentViewControllerDelegate <SocializeBaseViewControllerDelegate>
- (void)postCommentViewController:(SZComposeCommentMessageViewController*)composeCommentViewController didCreateComment:(id<SocializeComment>)comment;
@end