#import "create_like_button.h"

// begin-snippet

@implementation CreateLikeButtonViewController
@synthesize likeButton = likeButton_;


// Implementation

// Instantiate the action bar in your view controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.likeButton == nil) {
        SocializeEntity *entity = [SocializeEntity entityWithKey:@"hot_ticket_1" name:@"A Hot Ticket"];
        self.likeButton = [[SZLikeButton alloc] initWithFrame:CGRectMake(120, 30, 0, 0) entity:entity viewController:self tabBarStyle:YES];
        
        // Turn of automatic sizing of the like button (default NO)
        // likeButton.autoresizeDisabled = YES;
        
        // Hide the count display
        // likeButton.hideCount = YES;
        
        [self.view addSubview:self.likeButton];
    }
}


@end

// end-snippet


@implementation CreateLikeButtonViewController (AdvancedUsage)

// begin-notification-snippet

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeButtonChanged:) name:SZLikeButtonDidChangeStateNotification object:self.likeButton];
    }
    
    return self;
}

- (void)likeButtonChanged:(NSNotification*)notification {
    NSLog(@"You've changed, %@", [notification object]);
}

// end-notification-snippet

// begin-refresh-snippet

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.likeButton refresh];
}

// end-refresh-snippet


// begin-entity-snippet

- (void)changeLikeButtonEntity {
    SocializeEntity *newEntity = [SocializeEntity entityWithKey:@"new_entity" name:@"New Entity"];
    self.likeButton.entity = newEntity;
}

// end-entity-snippet

@end