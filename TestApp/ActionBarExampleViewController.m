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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.actionBar = [[SZActionBar alloc] initWithFrame:CGRectMake(0, 300, 0, 0)];
    [self.view addSubview:self.actionBar];
    
    self.oldActionBar = [SocializeActionBar actionBarWithKey:@"Something" name:@"Something" presentModalInController:self];
    [self.view addSubview:self.oldActionBar.view];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
