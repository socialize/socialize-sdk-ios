//
//  SZShareDialogView.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZShareDialogView.h"
#import "UITableView+Resize.h"

@implementation SZShareDialogView
@synthesize continueButton = continueButton_;
@synthesize headerImageView = headerImageView_;
@synthesize headerView = headerView_;
@synthesize tableView = tableView_;
@synthesize containerView = containerView_;
@synthesize footerView = footerView_;

- (void)dealloc {
    self.continueButton = nil;
    self.headerImageView = nil;
    self.headerView = nil;
    self.tableView = nil;
    self.containerView = nil;
    self.footerView = nil;
    
    [super dealloc];
}

- (void)awakeFromNib {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:25/255.0f green:31/255.0f blue:37/255.0f alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setBackgroundView:nil];            
}

- (void)layoutSubviews {
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // Hide upper image on phone, in landscape
        self.containerView.rows = [NSArray arrayWithObjects:self.tableView, nil];
    } else {
        self.containerView.rows = [NSArray arrayWithObjects:self.headerView, self.tableView, nil];
    }
    
    [self.tableView sizeToCells];
    [self.containerView layoutRows];
}

@end
