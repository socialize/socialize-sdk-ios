//
//  appbuildrAppDelegate.h
//  appbuildr
//
//  Created by Isaac Mosquera on 1/8/09.
//  Copyright appmakr 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebpageViewController.h"
#import "FeedTableViewController.h"
#import "SplashViewController.h"
#import "LoginViewController.h"
#import "PhoneGapViewController.h"
#import "GlobalVariables.h"
#import "SocializeContainerView.h"
#import "FBConnect.h"
#import "SocializeService.h"

@class appbuildrViewController;

@interface appbuildrAppDelegate : NSObject <UIApplicationDelegate,SocializeServiceDelegate, LoginViewControllerDelegate, GlobalVariablesDelegate> {
	
	IBOutlet UIWindow		*window;
	UINavigationController  *navigationController;
	UIViewController	    *rootViewController;
	SocializeContainerView	*containerView;
	UITabBarController      *tabBarController;
	WebpageViewController   *webpageController;
	SplashViewController    *splashViewController;
	UIActivityIndicatorView *_loadingIndicatorView;
	SocializeService		*socializeService;

	// tmp variable to remove it soon
	BOOL					_socializeSweptUp;
}

-(void)continueLaunching;
-(UIImage *)addHeaderBorder:(UINavigationController *)aNavigationController;
-(void)persistTabOrder;
-(void)showAppExpiredAlertWithMessage:(NSString*)myMessage;
-(void)retainActivityIndicator;
-(void)releaseActivityIndicator;
-(void)hasGeoRssTabIn:(NSArray *)modules;
-(void)hideSocializeTabBar;
-(void)unHideSocializeTabBar;

@property (nonatomic, retain) UITabBarController	 *tabBarController;
@property (nonatomic, retain) UIWindow				 *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIViewController		 *rootViewController;
@property (nonatomic, retain) WebpageViewController  *webpageController;


@end


