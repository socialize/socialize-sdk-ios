#import "create_action_bar_no_auto.h"

@implementation CreateActionBarNoAutoViewController
@synthesize actionBar = actionBar_;

// begin-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.actionBar == nil) {
        self.actionBar = [SocializeActionBar actionBarWithKey:@"http://www.example.com/object/1234" name:@"My Object" presentModalInController:self];
        self.actionBar.noAutoLayout = YES;
        self.actionBar.view.frame = CGRectMake(0, 400, 320, SOCIALIZE_ACTION_PANE_HEIGHT);
        [self.view addSubview:self.actionBar.view];
    }
}

// end-snippet

@end
