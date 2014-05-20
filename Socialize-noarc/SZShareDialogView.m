//
//  SZShareDialogView.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZShareDialogView.h"
#import "UITableView+Resize.h"
#import "socialize_globals.h"

@implementation SZShareDialogView
@synthesize headerImageView = headerImageView_;
@synthesize headerView = headerView_;
@synthesize tableView = tableView_;
@synthesize containerView = containerView_;
@synthesize footerView = footerView_;

- (void)dealloc {
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

- (void)setHeaderView:(UIView *)headerView {
    NonatomicRetainedSetToFrom(headerView_, headerView);
    [self setNeedsLayout];
}

- (void)setFooterView:(UIView *)footerView {
    NonatomicRetainedSetToFrom(footerView_, footerView);
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    if ([self.tableView numberOfSections] > 0) {
        [self.tableView sizeToCells];
    }
    
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // Hide upper image on phone, in landscape
        self.containerView.rows = [NSArray arrayWithObjects:self.tableView, nil];
    } else {
        self.containerView.rows = [NSArray arrayWithObjects:self.headerView, self.tableView, self.footerView, nil];
    }

    [self.containerView layoutRows];
}

@end
