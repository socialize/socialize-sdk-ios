#import "create_action_bar.h"

@implementation CreateActionBarViewController
@synthesize actionBar = actionBar_;

// begin-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.actionBar == nil) {
        self.actionBar = [SZActionBar actionBarWithKey:@"http://www.example.com/object/1234" name:@"Something" presentModalInController:self];
        [self.view addSubview:self.actionBar.view];
    }
}

// end-snippet

@end
