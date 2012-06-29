#import "create_action_bar.h"

@implementation CreateActionBarViewController
@synthesize actionBar = _actionBar;
@synthesize entity = _entity;
// begin-simple-create-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
    }
}

@end

// end-simple-create-snippet

@implementation CreateActionBarViewController (AsViewDefaultFrame)


// begin-default-view-create-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBar defaultActionBarWithFrame:CGRectNull entity:self.entity viewController:self];
        [self.view addSubview:self.actionBar];
    }
}

// end-default-view-create-snippet

@end

@implementation CreateActionBarViewController (AsViewTopFrame)


// begin-top-view-create-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBar defaultActionBarWithFrame:CGRectZero entity:self.entity viewController:self];
        self.actionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.actionBar];
    }
}

// end-top-view-create-snippet

@end

@implementation CreateActionBarViewController (CustomButtons)

// begin-customize-buttons-create-snippet

- (void)emailButtonPressed:(id)sender {
    [SZShareUtils shareViaEmailWithViewController:self entity:self.entity success:nil failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBar defaultActionBarWithFrame:CGRectNull entity:self.entity viewController:self];
        
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
        
        [self.view addSubview:self.actionBar];
    }
}

// end-customize-buttons-create-snippet

@end

