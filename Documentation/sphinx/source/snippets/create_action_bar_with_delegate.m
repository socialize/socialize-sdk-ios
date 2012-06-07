#import "create_action_bar_with_delegate.h"

@implementation CreateActionBarWithDelegateViewController
@synthesize actionBar = actionBar_;

// begin-snippet

// Implementation

// Instantiate the action bar in your view controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.actionBar == nil) {
        self.actionBar = [SZActionBar actionBarWithKey:@"http://www.example.com/object/1234" name:@"My Object" presentModalInController:self];
        self.actionBar.delegate = self;
        [self.view addSubview:self.actionBar.view];
    }
}

- (void)actionBar:(SZActionBar*)actionBar wantsDisplayActionSheet:(UIActionSheet*)actionSheet {
    [actionSheet showFromRect:CGRectMake(50, 50, 50, 50) inView:self.view animated:YES];
}


// end-snippet

@end
