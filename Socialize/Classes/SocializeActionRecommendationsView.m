//
//  SocializeRecommendationsView.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActionRecommendationsView.h"

@implementation SocializeActionRecommendationsView
@synthesize raised = raised_;
@synthesize headerView = headerView_;
@synthesize tableView = tableView_;
@synthesize delegate = delegate_;
@synthesize shown = shown_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, RECOMMENDATIONS_HEADER_HEIGHT)] autorelease];
        UIImage *backgroundImage = [UIImage imageNamed:@"toolbar_bg.png"];
        self.headerView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        [self addSubview:self.headerView];
//        self.backgroundColor = [UIColor greenColor];
        self.backgroundColor = [UIColor greenColor];
        
        CGRect tableFrame = CGRectMake(0, RECOMMENDATIONS_HEADER_HEIGHT, 320, RECOMMENDATIONS_HEIGHT - RECOMMENDATIONS_HEADER_HEIGHT);
        self.tableView = [[[UITableView alloc] initWithFrame:tableFrame] autorelease];
        self.tableView.backgroundColor = [UIColor colorWithRed:50/255.0f green:58/255.0f blue:67/255.0f alpha:1.0];

        self.tableView.separatorColor = [UIColor darkGrayColor];
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        [self addSubview:self.tableView];
        // Initialization code
    }
    return self;
}

- (void)setDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate {
    self.tableView.dataSource = delegate;
    self.tableView.delegate = delegate;
}

- (void)raise {
    if (self.raised)
        return;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect f = self.frame;
    f.origin.y -= RECOMMENDATIONS_RAISE_OFFSET;
    self.frame = f;
    [UIView commitAnimations];
    self.raised = YES;
}

- (void)lower {
    if (!self.raised)
        return;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect f = self.frame;
    f.origin.y += RECOMMENDATIONS_RAISE_OFFSET;
    self.frame = f;
    [UIView commitAnimations];
    self.raised = NO;
}

- (void)hide {
    if (!self.shown)
        return;
    
    [UIView beginAnimations:nil context:NULL];
    if (self.raised) {
        [UIView setAnimationDuration:0.5];
    } else {
        [UIView setAnimationDuration:0.3];
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect f = self.frame;
    if (self.raised) {
        f.origin.y += RECOMMENDATIONS_RAISE_OFFSET;
    }
    f.origin.y += RECOMMENDATIONS_HEADER_HEIGHT;
    self.frame = f;
    [UIView commitAnimations];
    self.shown = NO;
    self.raised = NO;
}

- (void)show {
    if (self.shown)
        return;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];

    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect f = self.frame;
    f.origin.y -= RECOMMENDATIONS_HEADER_HEIGHT;
    self.frame = f;
    [UIView commitAnimations];
    self.shown = YES;
}


- (void)toggle {
    if (self.raised) {
        [self lower];
    } else {
        [self raise];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
    [super touchesBegan:touches withEvent:event];
    
    [self toggle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
