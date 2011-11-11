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
#import "SocializeShareBuilder.h"
#import "SocializeFacebookInterface.h"
#import "SocializeProfileViewController.h"

@interface SocializePostShareViewController ()
- (void)createShareOnSocializeServer;
- (void)createShareOnFacebookServer;
@end

@implementation SocializePostShareViewController
@synthesize shareObject = shareObject_;
@synthesize shareBuilder = shareBuilder_;

+ (UINavigationController*)postShareViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL {
    SocializePostShareViewController *postShareViewController = [self postShareViewControllerWithEntityURL:entityURL];
    UINavigationController *navigationController = [UINavigationController socializeNavigationControllerWithRootViewController:postShareViewController];
    return navigationController;    
}

+ (SocializePostShareViewController*)postShareViewControllerWithEntityURL:(NSString *)entityURL {
    SocializePostShareViewController *postShareViewController = [[[SocializePostShareViewController alloc]
                                                                  initWithNibName:@"SocializePostShareViewController"
                                                                  bundle:nil
                                                                  entityUrlString:entityURL]
                                                                 autorelease];
    return postShareViewController;
}

- (void)dealloc {
    self.shareObject = nil;
    self.shareBuilder = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New Share";
    
    [self authenticateWithFacebook];
}

- (void)createShare {
    if (self.shareObject == nil) {
        [self createShareOnSocializeServer];
        return;
    }
    [self createShareOnFacebookServer];
}

- (void)shareComplete {
    [self stopLoading];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)shareFailed:(NSError*)error {
    [self stopLoading];
    [self showAllertWithText:[error localizedDescription] andTitle:@"Error Posting Share"];
}

- (void)createShareOnSocializeServer {
    [self startLoading];
    [self.socialize createShareForEntityWithKey:self.entityURL medium:SocializeShareMediumFacebook text:commentTextView.text];
}

- (SocializeShareBuilder*)shareBuilder {
    if (shareBuilder_ == nil) {
        shareBuilder_ = [[SocializeShareBuilder alloc] init];
        shareBuilder_.shareProtocol = [[[SocializeFacebookInterface alloc] init] autorelease];
        shareBuilder_.successAction = ^{
            [self shareComplete];
        };
        shareBuilder_.errorAction = ^(NSError *error) {
            [self shareFailed:error];
        };

    }
    return shareBuilder_;
}

- (void)createShareOnFacebookServer {
    self.shareBuilder.shareObject = self.shareObject;
    [self.shareBuilder performShareForPath:@"me/feed"];
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

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self shareFailed:error];
}

@end
