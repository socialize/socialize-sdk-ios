//
//  SocializePostCommentViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/10/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializePostCommentViewController.h"
#import "SocializeLocationManager.h"
#import "CommentMapView.h"
#import "UINavigationController+Socialize.h"
#import "SocializeAuthViewController.h"

@interface SocializePostCommentViewController ()
- (void)configureFacebookButton;
@end

@implementation SocializePostCommentViewController
@synthesize commentObject = commentObject_;
@synthesize commentSentToFacebook = commentSentToFacebook_;
@synthesize facebookButton = facebookButton_;
@synthesize delegate = delegate_;
@synthesize unsubscribeButton = unsubscribeButton_;
@synthesize dontSubscribeToDiscussion = dontSubscribeToDiscussion_;
@synthesize enableSubscribeButton = enabledSubscribeButton_;
@synthesize subscribeContainer = subscribeContainer_;

+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL delegate:(id<SocializePostCommentViewControllerDelegate>)delegate {
    SocializePostCommentViewController *postCommentViewController = [self postCommentViewControllerWithEntityURL:entityURL];
    postCommentViewController.delegate = delegate;
    UINavigationController *navigationController = [UINavigationController socializeNavigationControllerWithRootViewController:postCommentViewController];
    return navigationController;    
}

+ (SocializePostCommentViewController*)postCommentViewControllerWithEntityURL:(NSString*)entityURL {
    SocializePostCommentViewController *postCommentViewController = [[[SocializePostCommentViewController alloc]
                                                       initWithNibName:@"SocializePostCommentViewController" bundle:nil entityUrlString:entityURL]
                                                      autorelease];
    return postCommentViewController;
}

- (void)dealloc {
    self.facebookButton = nil;
    self.commentObject = nil;
    self.unsubscribeButton = nil;
    self.enableSubscribeButton = nil;
    self.subscribeContainer = nil;

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New Comment";
    [self configureFacebookButton];
    [self addSocializeRoundedGrayButtonImagesToButton:self.unsubscribeButton];
    self.dontSubscribeToDiscussion = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.facebookButton = nil;
    self.unsubscribeButton = nil;
    self.enableSubscribeButton = nil;
    self.subscribeContainer = nil;
}

- (void)configureFacebookButton {
    if ([self.socialize isAuthenticatedWithFacebook]) {
        BOOL dontPost = [[[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY] boolValue];
        self.facebookButton.hidden = NO;
        self.facebookButton.selected = !dontPost;
    } else {
        self.facebookButton.hidden = YES;
    }
}

- (void)createCommentOnSocializeServer {
    [self startLoading];
    
    if(self.locationManager.shouldShareLocation)
    {
        NSNumber* latitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.longitude];        
        [self.socialize createCommentForEntityWithKey:self.entityURL comment:commentTextView.text longitude:longitude latitude:latitude subscribe:!self.dontSubscribeToDiscussion];
    }
    else
        [self.socialize createCommentForEntityWithKey:self.entityURL comment:commentTextView.text longitude:nil latitude:nil];
}

- (BOOL)shouldSendToFacebook {
    return self.facebookButton.selected && !self.facebookButton.hidden;
}

- (void)executeAfterModalDismissDelay:(void (^)())block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, MIN_MODAL_DISMISS_INTERVAL * NSEC_PER_SEC), 
                   dispatch_get_main_queue(),
                   block);
}

- (void)dismissSelf {
    // In the case that the user just came back from the SocializeAuthViewController, and the 
    // socialize server finishes creating the comment before the modal dismissal animation has played,
    // we need to hack a delay for iOS5 or the second dismissal will not happen
    
    // Double animated dismissal does not work on iOS5 (but works in iOS4)
    // Allow previous modal dismisalls to complete. iOS5 added dismissViewControllerAnimated:completion:, which
    // we could also use for the previous dismissal, but this is a little simpler and lets us ignore version differences.
    [self executeAfterModalDismissDelay:^{
        [self stopLoadAnimation];
        [self dismissModalViewControllerAnimated:YES];
    }];
}

- (void)notifyDelegateOrDismissSelf {
    if ([self.delegate respondsToSelector:@selector(postCommentViewController:didCreateComment:)]) {
        [self executeAfterModalDismissDelay:^{
            [self stopLoadAnimation];
            [self.delegate postCommentViewController:self didCreateComment:self.commentObject];
        }];
    } else {
        [self dismissSelf];
    }
}

- (void)finishCreateComment {
    
    // Create the comment object if not already created.
    if (self.commentObject == nil) {
        [self createCommentOnSocializeServer];
        return;
    }
    
    // Send activity to facebook if the user requested it
    if (!self.commentSentToFacebook && [self shouldSendToFacebook]) {
        [self sendActivityToFacebookFeed:self.commentObject];
        return;
    }
    
    [self notifyDelegateOrDismissSelf];
}
- (void)afterLoginAction {
    [self configureFacebookButton];
}

- (void)facebookButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

-(void)sendButtonPressed:(UIButton*)button {
    if (![self.socialize isAuthenticatedWithFacebook]) {
        [self presentModalViewController:self.authViewController animated:YES];
    } else {
        [self finishCreateComment];
    }
}

- (void)setDontSubscribeToDiscussion:(BOOL)dontSubscribeToDiscussion {
    dontSubscribeToDiscussion_ = dontSubscribeToDiscussion;
    self.enableSubscribeButton.selected = !self.dontSubscribeToDiscussion;
}

-(IBAction)enableSubscribeButtonPressed:(id)sender {

    if (self.dontSubscribeToDiscussion) {
        [self setDontSubscribeToDiscussion:NO];
        [self setSubviewForLowerContainer:self.subscribeContainer];
    } else {
        if ([commentTextView isFirstResponder]) 
        {
            [self setSubviewForLowerContainer:self.subscribeContainer];
            [commentTextView resignFirstResponder];          
        }
        else
        {
            [commentTextView becomeFirstResponder];
        }            
    }
}

-(IBAction)unsubscribeButtonPressed:(id)sender {
    [self setDontSubscribeToDiscussion:YES];
    [commentTextView becomeFirstResponder];
}

- (void)sendActivityToFacebookFeedSucceeded {
    self.commentSentToFacebook = YES;
    [self finishCreateComment];
}

- (void)sendActivityToFacebookFeedCancelled {
}

- (void)sendActivityToFacebookFeedFailed:(NSError *)error {
    // Just skip Facebook send
    self.commentSentToFacebook = YES;
    [self finishCreateComment];
}

-(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object {
    if ([object conformsToProtocol:@protocol(SocializeComment)]) {
        self.commentObject = (id<SocializeComment>)object;
        [self finishCreateComment];
    }
}

-(void)authorizationSkipped {
    [self finishCreateComment];    
}

-(void)socializeAuthViewController:(SocializeAuthViewController *)authViewController didAuthenticate:(id<SocializeUser>)user {
    // FIXME [#20995319] auth flow in wrong place
    [self afterLoginAction];
    [self finishCreateComment];    
}


@end
