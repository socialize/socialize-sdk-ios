//
//  ActionBarExampleViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "ActionBarExampleViewController.h"
#import <Socialize/Socialize.h>
#import <BlocksKit/BlocksKit.h>

@interface ActionBarExampleViewController ()

@end

@implementation ActionBarExampleViewController
@synthesize actionBar = _actionBar;
@synthesize oldActionBar = _oldActionBar;
@synthesize entity = _entity;

//- (void)dealloc {
////    self.actionBar.viewController = nil;
//}

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
    
    __unsafe_unretained id weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)emailButtonPressed:(id)sender {
    [SZShareUtils shareViaEmailWithViewController:self entity:self.entity success:nil failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBar defaultActionBarWithFrame:CGRectNull entity:self.entity viewController:self];
        [self.view addSubview:self.actionBar];
//        [self customizeButtons];
//        [self makeActionBarVertical];
    }
}

// begin-customize-action-bar-buttons-snippet

- (void)customizeButtons {
    SZActionButton *panicButton = [SZActionButton actionButtonWithIcon:nil title:@"Panic"];
    panicButton.actionBlock = ^(SZActionButton *button, SZActionBar *bar) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    };
    
    self.actionBar.itemsRight = [NSArray arrayWithObjects:panicButton, [SZActionButton commentButton], nil];
    
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [emailButton setImage:[UIImage imageNamed:@"socialize-selectnetwork-email-icon.png"] forState:UIControlStateNormal];
    [emailButton sizeToFit];
    [emailButton addTarget:self action:@selector(emailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.actionBar.itemsLeft = [NSArray arrayWithObjects:[SZActionButton viewsButton], emailButton, nil];
}

// end-customize-action-bar-buttons-snippet

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
