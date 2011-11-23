//
//  SocializeActivityViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/22/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeTableViewController.h"

@class SocializeActivityTableViewCell;
@protocol SocializeActivityViewControllerDelegate;

@interface SocializeActivityViewController : SocializeTableViewController
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSInteger currentUser;
@property (nonatomic, retain) IBOutlet SocializeActivityTableViewCell *activityTableViewCell;

- (IBAction)viewProfileButtonTouched:(UIButton*)button;
@end

@protocol SocializeActivityViewControllerDelegate <NSObject>
@optional
- (void)activityViewController:(SocializeActivityViewController*)activityViewController profileTappedForUser:(id<SocializeUser>)user;
@end