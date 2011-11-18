//
//  SocializePostCommentViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/10/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeComposeMessageViewController.h"
#import "SocializeAuthViewController.h"

@interface SocializePostCommentViewController : SocializeComposeMessageViewController <SocializeAuthViewControllerDelegate>
+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL;
+ (SocializePostCommentViewController*)postCommentViewControllerWithEntityURL:(NSString*)entityURL;
- (void)finishCreateComment;
@property (nonatomic, retain) id<SocializeComment> commentObject;
@property (nonatomic, retain) IBOutlet UIButton *facebookButton;
@property (nonatomic, assign) BOOL commentSentToFacebook;

- (IBAction)facebookButtonPressed:(UIButton*)sender;
@end
