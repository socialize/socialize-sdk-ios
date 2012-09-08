//
//  SZStatusView.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/27/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZStatusView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SZStatusView
@synthesize centerContentView;

- (id)initWithFrame:(CGRect)frame contentNibName:(NSString*)contentNibName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize centerSize = [[self class] centerSize];
        self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, centerSize.width, centerSize.height)];
        self.centerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.centerView.layer.cornerRadius = 12.f;
        [self addSubview:self.centerView];

        if ([contentNibName length] > 0) {
            [[NSBundle mainBundle] loadNibNamed:contentNibName owner:self options:nil];
            [self.centerView addSubview:self.centerContentView];
        }
    }
    return self;
}

+ (CGSize)centerSize {
    return CGSizeMake(140, 120);
}

- (void)layoutSubviews {
    self.centerView.center = self.center;
}

+ (SZStatusView*)successStatusViewWithFrame:(CGRect)frame {
    SZStatusView *statusView = [[SZStatusView alloc] initWithFrame:frame contentNibName:@"SZStatusImageLabelView"];
    return statusView;
}

- (void)showAndHideInKeyWindowWithDuration:(NSTimeInterval)duration {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.frame = [[UIScreen mainScreen] applicationFrame];
    
    [window addSubview:self];
    
    self.alpha = 1.f;
    
    double delayInSeconds = duration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });

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
