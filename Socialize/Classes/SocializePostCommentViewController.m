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
#import "SocializeSubscriptionService.h"
#import "SocializeCommentCreator.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"
#import "SocializeFacebookAuthenticator.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeUIDisplayProxy.h"

@interface SocializePostCommentViewController ()
- (void)configureFacebookButton;
- (void)configureForNewUser;
@end

@implementation SocializePostCommentViewController
@synthesize commentObject = commentObject_;
@synthesize facebookButton = facebookButton_;
@synthesize delegate = delegate_;
@synthesize unsubscribeButton = unsubscribeButton_;
@synthesize dontSubscribeToDiscussion = dontSubscribeToDiscussion_;
@synthesize enableSubscribeButton = enabledSubscribeButton_;
@synthesize subscribeContainer = subscribeContainer_;
@synthesize twitterButton = twitterButton_;

+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL delegate:(id<SocializePostCommentViewControllerDelegate>)delegate {
    SocializePostCommentViewController *postCommentViewController = [self postCommentViewControllerWithEntityURL:entityURL];
    postCommentViewController.delegate = delegate;
    UINavigationController *navigationController = [UINavigationController socializeNavigationControllerWithRootViewController:postCommentViewController];
    return navigationController;    
}

+ (SocializePostCommentViewController*)postCommentViewControllerWithEntityURL:(NSString*)entityURL {
    SocializePostCommentViewController *postCommentViewController = [[[SocializePostCommentViewController alloc]
                                                       initWithEntityUrlString:entityURL]
                                                      autorelease];
    return postCommentViewController;
}

- (void)dealloc {
    self.facebookButton = nil;
    self.commentObject = nil;
    self.unsubscribeButton = nil;
    self.enableSubscribeButton = nil;
    self.subscribeContainer = nil;
    self.twitterButton = nil;

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"New Comment";
    [self configureFacebookButton];
    [self addSocializeRoundedGrayButtonImagesToButton:self.unsubscribeButton];
    self.dontSubscribeToDiscussion = NO;
    
    if ([self.socialize isAuthenticated]) {
        [self configureForNewUser];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.facebookButton = nil;
    self.unsubscribeButton = nil;
    self.enableSubscribeButton = nil;
    self.subscribeContainer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configureMessageActionButtons {
    NSMutableArray *buttons = [NSMutableArray array];

    if ([SocializeThirdPartyTwitter available]) {
        [buttons addObject:self.twitterButton];
    } else {
        DebugLog(SOCIALIZE_TWITTER_NOT_CONFIGURED_MESSAGE);
    }
    
    if ([SocializeThirdPartyFacebook available]) {
        [buttons addObject:self.facebookButton];
    } else {
        DebugLog(SOCIALIZE_FACEBOOK_NOT_CONFIGURED_MESSAGE);
    }
    
    if ([self.socialize notificationsAreConfigured]) {
        [buttons addObject:self.enableSubscribeButton];
    } else {
        DebugLog(SOCIALIZE_NOTIFICATIONS_NOT_CONFIGURED_MESSAGE);
    }
    
    self.messageActionButtons = buttons;
}

- (void)configureFacebookButton {
    BOOL dontPost = [[[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY] boolValue];
    BOOL isLinked = [SocializeThirdPartyFacebook isLinkedToSocialize];
    self.facebookButton.selected = isLinked && !dontPost;
}

- (void)configureTwitterButton {
    BOOL dontPost = [[[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY] boolValue];
    BOOL isLinked = [SocializeThirdPartyTwitter isLinkedToSocialize];
    self.twitterButton.selected = isLinked && !dontPost;
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

- (void)createComment {
    [self startLoading];
    
    SocializeEntity *entity = [SocializeEntity entityWithKey:self.entityURL name:nil];
    SocializeComment *comment = [SocializeComment commentWithEntity:entity text:commentTextView.text];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey] boolValue]) {
        NSNumber* latitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.longitude];        
        comment.lat = latitude;
        comment.lng = longitude;
    }
    
    [SocializeCommentCreator createComment:comment options:nil display:nil
                                   success:^(id<SocializeComment> comment) {
                                       self.commentObject = comment;
                                       [self notifyDelegateOrDismissSelf];
                                   } failure:^(NSError *error) {
                                       [self stopLoading];
                                       [self failWithError:error];
                                   }];
}

- (void)configureForNewUser {
    [self getSubscriptionStatus];
}

- (void)afterLoginAction:(BOOL)userChanged {
    [super afterLoginAction:userChanged];
    
    [self configureFacebookButton];
    [self configureTwitterButton];
    [self configureMessageActionButtons];
    
    if (userChanged) {
        [self configureForNewUser];
    }
}

- (void)setPostToFacebook:(BOOL)postToFacebook {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!postToFacebook] forKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY];
}

- (void)setPostToTwitter:(BOOL)postToTwitter {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!postToTwitter] forKey:kSOCIALIZE_DONT_POST_TO_TWITTER_KEY];
}

- (void)facebookButtonPressed:(UIButton *)sender {
    if (!sender.selected && ![SocializeThirdPartyFacebook isLinkedToSocialize]) {
        [SocializeFacebookAuthenticator authenticateViaFacebookWithOptions:nil display:self
                                                                   success:^{
                                                                       [self setPostToFacebook:YES];
                                                                       [self configureFacebookButton];
                                                                   } failure:^(NSError *error) {
                                                                       [self configureFacebookButton];
                                                                   }];
    } else {
        sender.selected = !sender.selected;
        [self setPostToFacebook:sender.selected];
    }
}

- (IBAction)twitterButtonPressed:(UIButton*)sender {
    if (!sender.selected && ![SocializeThirdPartyTwitter isLinkedToSocialize]) {
        [SocializeTwitterAuthenticator authenticateViaTwitterWithOptions:nil
                                                                  display:self
                                                                  success:^{
                                                                      [self setPostToTwitter:YES];
                                                                      [self configureTwitterButton];
                                                                  } failure:^(NSError *error) {
                                                                      [self configureTwitterButton];
                                                                  }];
    } else {
        sender.selected = !sender.selected;
        [self setPostToTwitter:sender.selected];
    }

}


-(void)sendButtonPressed:(UIButton*)button {
    if ([self shouldShowAuthViewController]) {
        [self presentModalViewController:self.authViewController animated:YES];
    } else {
        [self createComment];
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

-(void)authorizationSkipped {
    [self createComment];    
}

-(void)socializeAuthViewController:(SocializeAuthViewController *)authViewController didAuthenticate:(id<SocializeUser>)user {
    // FIXME [#20995319] auth flow in wrong place
    [self afterLoginAction:YES];
    [self createComment];    
}

- (BOOL)elementsHaveInactiveSubscription:(NSArray*)elements {
    for (id<SocializeSubscription> subscription in elements) {
        if (![subscription subscribed]) {
            return YES;
        }
    }
    
    return NO;
}

-(void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    if ([service isKindOfClass:[SocializeSubscriptionService class]]) {
        // The only time we want the button off is if they have previously posted without subscription
        BOOL subscribeHasBeenDisabled = [self elementsHaveInactiveSubscription:dataArray];
        self.enableSubscribeButton.enabled = YES;
        [self setDontSubscribeToDiscussion:subscribeHasBeenDisabled];
        
    } else {
        [super service:service didFetchElements:dataArray];
    }
}

- (void)getSubscriptionStatus {
    self.enableSubscribeButton.enabled = NO;
    [self.socialize getSubscriptionsForEntityKey:self.entityURL first:nil last:nil];
}


@end
