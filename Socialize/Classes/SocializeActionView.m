//
//  SocializeActionLayoutView.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActionView.h"

@implementation SocializeActionView
@synthesize barView = barView_;
@synthesize recommendationsView = recommendationsView_;
@synthesize delegate = delegate_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.barView = [[[SocializeActionBarView alloc] initWithFrame:CGRectZero] autorelease];
        self.frame = CGRectMake(0, 0, 320, 460);
        self.recommendationsView = [[[SocializeActionRecommendationsView alloc] initWithFrame:CGRectZero] autorelease];
        [self addSubview:self.barView];
        [self addSubview:self.recommendationsView];
//        self.userInteractionEnabled = NO;
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setDelegate:(id<SocializeActionViewDelegate, SocializeActionBarViewDelegate, UITableViewDelegate, UITableViewDataSource>)delegate {
    delegate_ = delegate;
    [self.barView setDelegate:delegate];
    [self.recommendationsView setDelegate:delegate];
}

- (void)positionBar {
    self.barView.frame = CGRectMake(0, self.superview.frame.size.height - ACTION_PANE_HEIGHT, self.superview.frame.size.width,  ACTION_PANE_HEIGHT);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self positionBar];
    
    [self sendSubviewToBack:self.recommendationsView];
    CGRect recommendationsFrame = self.barView.frame;
    recommendationsFrame.origin.y -= 30;
    recommendationsFrame.size = CGSizeMake(RECOMMENDATIONS_WIDTH, RECOMMENDATIONS_HEIGHT);
    self.recommendationsView.frame = recommendationsFrame;
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [self.barView hitTest:point withEvent:event];
    if (hitView != nil) return hitView;
    hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    
    return hitView;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if (newWindow != nil) {
        if ([self.delegate respondsToSelector:@selector(socializeActionViewWillAppear:)]) {
            [self.delegate socializeActionViewWillAppear:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(socializeActionViewWillDisappear:)]) {
            [self.delegate socializeActionViewWillDisappear:self];
        }
    }
}




@end
