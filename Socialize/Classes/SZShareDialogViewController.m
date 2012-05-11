//
//  SZShareDialogViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZShareDialogViewController.h"

@interface SZShareDialogViewController ()

@end

@implementation SZShareDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:50/255.0f green:58/255.0f blue:67/255.0f alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:25/255.0f green:31/255.0f blue:37/255.0f alpha:1.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSInteger)socialNetworkSection {
    if ([SocializeThirdParty
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
