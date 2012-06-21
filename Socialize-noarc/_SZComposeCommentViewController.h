//
//  _SZComposeCommentViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/10/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeComposeMessageViewController.h"
#import "_SZLinkDialogViewController.h"
#import "SZComposeCommentViewControllerDelegate.h"
#import "SZCommentOptions.h"

@interface _SZComposeCommentViewController : SocializeComposeMessageViewController <_SZLinkDialogViewControllerDelegate>
+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL delegate:(id<SZComposeCommentViewControllerDelegate>)delegate;
+ (_SZComposeCommentViewController*)postCommentViewControllerWithEntityURL:(NSString*)entityURL;
+ (_SZComposeCommentViewController*)composeCommentViewControllerWithEntity:(id<SZEntity>)entity;
@property (nonatomic, assign) id<SZComposeCommentViewControllerDelegate> delegate;
@property (nonatomic, retain) id<SocializeComment> commentObject;
@property (nonatomic, retain) IBOutlet UIButton *facebookButton;
@property (nonatomic, retain) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) IBOutlet UIButton *unsubscribeButton;
@property (nonatomic, retain) IBOutlet UIButton *enableSubscribeButton;
@property (nonatomic, assign) BOOL dontSubscribeToDiscussion;
@property(nonatomic, retain) IBOutlet UIView *subscribeContainer;
@property (nonatomic, copy) void (^completionBlock)(id<SZComment>);

-(IBAction)unsubscribeButtonPressed:(id)sender;
-(IBAction)enableSubscribeButtonPressed:(id)sender;
- (void)getSubscriptionStatus;
- (void)configureMessageActionButtons;
- (void)createComment;
@end

