//
//  SocializeActivityViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/22/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewController.h"

@class SocializeActivityTableViewCell;
@protocol SocializeActivityViewControllerDelegate;

@interface SocializeActivityViewController : SocializeBaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSInteger currentUser;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) IBOutlet SocializeActivityTableViewCell *activityTableViewCell;
@property (nonatomic, retain) NSMutableArray *activityArray;
@property (nonatomic, assign, readonly) BOOL waitingForActivity;
@property (nonatomic, assign, readonly) BOOL loadedAllActivity;
@property (nonatomic, retain) IBOutlet UIView *tableBackgroundView;

- (IBAction)viewProfileButtonTouched:(UIButton*)button;
@end

@protocol SocializeActivityViewControllerDelegate <NSObject>
@optional
- (void)activityViewControllerDidStartLoadingActivity:(SocializeActivityViewController*)activityViewController;
- (void)activityViewControllerDidStopLoadingActivity:(SocializeActivityViewController*)activityViewController;
- (void)activityViewController:(SocializeActivityViewController*)activityViewController profileTappedForUser:(id<SocializeUser>)user;
@end