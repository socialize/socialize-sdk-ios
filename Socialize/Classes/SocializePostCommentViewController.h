//
//  SocializePostCommentViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/10/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeComposeMessageViewController.h"

@interface SocializePostCommentViewController : SocializeComposeMessageViewController
+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL;
+ (SocializePostCommentViewController*)postCommentViewControllerWithEntityURL:(NSString*)entityURL;
- (void)createComment;
@end
