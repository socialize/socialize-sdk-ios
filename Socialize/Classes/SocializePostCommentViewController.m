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

@implementation SocializePostCommentViewController

+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL {
    SocializePostCommentViewController *postCommentViewController = [self postCommentViewControllerWithEntityURL:entityURL];
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
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New Comment";
}

- (void)createComment {
    [self startLoading];
    if(self.locationManager.shouldShareLocation)
    {
        NSNumber* latitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.longitude];        
        [self.socialize createCommentForEntityWithKey:self.entityURL comment:commentTextView.text longitude:longitude latitude:latitude];
    }
    else
        [self.socialize createCommentForEntityWithKey:self.entityURL comment:commentTextView.text longitude:nil latitude:nil];
}

- (void)afterUserRejectedFacebookAuthentication {
    [self createComment];
}

- (void)afterFacebookLoginAction {
    [self createComment];
}

-(void)sendButtonPressed:(UIButton*)button {
    if (![self.socialize isAuthenticatedWithFacebook]) {
        [self requestFacebookFromUser];
    } else {
        [self createComment];
    }
}

-(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object{   
#if 0
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:kSOCIALIZE_DONT_POST_TO_FACEBOOK_KEY] boolValue]) {
        if([self.socialize isAuthenticatedWithFacebook])
        {
            SocializeShareBuilder* shareBuilder = [[SocializeShareBuilder new] autorelease];
            shareBuilder.shareProtocol = [[SocializeFacebookInterface new] autorelease];
            shareBuilder.shareObject = (id<SocializeActivity>)object;
            [shareBuilder performShareForPath:@"me/feed"];
        }
    }
#endif
    
    // Rapid animated dismissal does not work on iOS5 (but works in iOS4)
    // Allow previous modal dismisalls to complete. iOS5 added dismissViewControllerAnimated:completion:, which
    // we would use here if backward compatibility was not required.   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, MIN_MODAL_DISMISS_INTERVAL * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopLoadAnimation];
        [self dismissModalViewControllerAnimated:YES];
    });
}

@end
