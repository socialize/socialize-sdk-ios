//
//  SZUserSettingsViewControllerViewController.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZUserSettingsViewControllerViewController.h"
#import "_SZUserSettingsViewController.h"

@interface SZUserSettingsViewControllerViewController ()
@property (nonatomic, assign) BOOL initialized;
@end

@implementation SZUserSettingsViewControllerViewController
@synthesize completionBlock = _completionBlock;
@synthesize initialized = _initialized;

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initializeIfNeeded];
}

- (void)initializeIfNeeded {
    if (!self.initialized) {
        _SZUserSettingsViewController *settings = [[_SZUserSettingsViewController alloc] init];
        [self pushViewController:settings animated:NO];
        self.initialized = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
