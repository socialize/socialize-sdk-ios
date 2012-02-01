//
//  SocializePostShareViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/10/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializePostShareViewController.h"
#import "UINavigationController+Socialize.h"
#import "SocializeLocationManager.h"
#import "CommentMapView.h"
#import "SocializeFacebookInterface.h"
#import "SocializeProfileViewController.h"

@interface SocializePostShareViewController ()
- (void)createShareOnSocializeServer;
@end

@implementation SocializePostShareViewController
@synthesize shareObject = shareObject_;

+ (UINavigationController*)postShareViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL {
    SocializePostShareViewController *postShareViewController = [self postShareViewControllerWithEntityURL:entityURL];
    UINavigationController *navigationController = [UINavigationController socializeNavigationControllerWithRootViewController:postShareViewController];
    return navigationController;    
}

+ (SocializePostShareViewController*)postShareViewControllerWithEntityURL:(NSString *)entityURL {
    SocializePostShareViewController *postShareViewController = [[[SocializePostShareViewController alloc]
                                                                  initWithEntityUrlString:entityURL]
                                                                 autorelease];
    return postShareViewController;
}

- (void)dealloc {
    self.shareObject = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutoAuthOnAppear {
    return NO;
}

- (void)afterLoginAction:(BOOL)userChanged {
    // The compose message base is auto disabling this after animation stops
    [self textViewDidChange:self.commentTextView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New Share";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self authenticateWithFacebook];    
}

- (void)createShare {
    if (self.shareObject == nil) {
        [self createShareOnSocializeServer];
        return;
    }
    [self sendActivityToFacebookFeed:self.shareObject];
}

- (void)sendActivityToFacebookFeedSucceeded {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createShareOnSocializeServer {
    [self startLoading];
    [self.socialize createShareForEntityWithKey:self.entityURL medium:SocializeShareMediumFacebook text:commentTextView.text];
}

- (void)sendButtonPressed:(UIButton*)button {
    [self createShare];
}

-(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object{
    if ([object conformsToProtocol:@protocol(SocializeShare)]) {
        self.shareObject = (id<SocializeShare>)object;
        // Finish creating the share
        [self createShare];
    }
}

@end
