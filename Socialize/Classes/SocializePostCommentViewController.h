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
#import "SocializePostCommentViewControllerDelegate.h"

@interface SocializePostCommentViewController : SocializeComposeMessageViewController <SocializeAuthViewControllerDelegate>
+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL delegate:(id<SocializePostCommentViewControllerDelegate>)delegate;
+ (SocializePostCommentViewController*)postCommentViewControllerWithEntityURL:(NSString*)entityURL;
@property (nonatomic, assign) id<SocializePostCommentViewControllerDelegate> delegate;
@property (nonatomic, retain) id<SocializeComment> commentObject;
@property (nonatomic, retain) IBOutlet UIButton *facebookButton;
@property (nonatomic, retain) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) IBOutlet UIButton *unsubscribeButton;
@property (nonatomic, retain) IBOutlet UIButton *enableSubscribeButton;
@property (nonatomic, assign) BOOL dontSubscribeToDiscussion;
@property(nonatomic, retain) IBOutlet UIView *subscribeContainer;

- (IBAction)facebookButtonPressed:(UIButton*)sender;
- (IBAction)twitterButtonPressed:(UIButton*)sender;
-(IBAction)unsubscribeButtonPressed:(id)sender;
-(IBAction)enableSubscribeButtonPressed:(id)sender;
- (void)getSubscriptionStatus;
- (void)configureMessageActionButtons;
- (void)createComment;
@end

