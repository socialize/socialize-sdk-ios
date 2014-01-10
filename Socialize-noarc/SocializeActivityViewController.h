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

@property (nonatomic, assign) IBOutlet id delegate;
@property (nonatomic, assign) NSInteger currentUser;
@property (nonatomic, retain) IBOutlet SocializeActivityTableViewCell *activityTableViewCell;
@property (nonatomic, assign) BOOL dontShowNames;
@property (nonatomic, assign) BOOL dontShowDisclosure;

- (IBAction)viewProfileButtonTouched:(UIButton*)button;
+ (NSString *)tableViewCellNibName;
@end

@protocol SocializeActivityViewControllerDelegate <NSObject>
- (void)activityViewController:(SocializeActivityViewController*)activityViewController profileTappedForUser:(id<SocializeUser>)user;
- (void)activityViewController:(SocializeActivityViewController*)activityViewController activityTapped:(id<SocializeActivity>)activity;
@end