//
//  ActionBarExampleViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "ActionBarExampleViewController.h"
#import <Socialize/Socialize.h>

@interface ActionBarExampleViewController ()

@end

@implementation ActionBarExampleViewController
@synthesize actionBar = _actionBar;
@synthesize oldActionBar = _oldActionBar;
@synthesize entity = _entity;

- (id)initWithEntity:(id<SZEntity>)entity {
    self = [super init];
    if (self) {
        self.entity = entity;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {

    if (self.actionBar == nil) {
        self.actionBar = [SZActionBarUtils showActionBarInViewController:self entity:self.entity options:nil];
        //    [self makeActionBarVertical];
    }
}

- (void)makeActionBarVertical {
    self.actionBar.transform = CGAffineTransformMakeRotation(M_PI_2);
    for (UIView *view in self.actionBar.itemsLeft) {
        view.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    
    for (UIView *view in self.actionBar.itemsRight) {
        view.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }

    self.actionBar.center = self.view.center;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
