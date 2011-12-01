//
//  SocializePostCommentViewControllerDelegate.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeComposeMessageViewController.h"

@class SocializePostCommentViewController;

@protocol SocializePostCommentViewControllerDelegate <SocializeComposeMessageViewControllerDelegate>
- (void)postCommentViewController:(SocializePostCommentViewController*)postCommentViewController didCreateComment:(id<SocializeComment>)comment;
@end