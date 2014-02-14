//
//  LoadingView.m
//  LoadingView
//
//  Created by Matt Gallagher on 12/04/09.
//  Copyright Matt Gallagher 2009. All rights reserved.
// 
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "SocializeLoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import <SZBlocksKit/BlocksKit.h>

//
// NewPathWithRoundRect
//
// Creates a CGPathRect with a round rect of the given radius.
//

CF_RETURNS_RETAINED
static CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,
					  rect.origin.x,
					  rect.origin.y + rect.size.height - cornerRadius);
	
	// Top left corner
	CGPathAddArcToPoint(path, NULL,
						rect.origin.x,
						rect.origin.y,
						rect.origin.x + rect.size.width,
						rect.origin.y,
						cornerRadius);
	
	// Top right corner
	CGPathAddArcToPoint(path, NULL,
						rect.origin.x + rect.size.width,
						rect.origin.y,
						rect.origin.x + rect.size.width,
						rect.origin.y + rect.size.height,
						cornerRadius);
	
	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
						rect.origin.x + rect.size.width,
						rect.origin.y + rect.size.height,
						rect.origin.x,
						rect.origin.y + rect.size.height,
						cornerRadius);
	
	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
						rect.origin.x,
						rect.origin.y + rect.size.height,
						rect.origin.x,
						rect.origin.y,
						cornerRadius);
	
	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
	
	return path;
}

@implementation SocializeLoadingView

@synthesize minDuration;
@synthesize timestamp;

//
// loadingViewInView:
//
// Constructor for this view. Creates and adds a loading view for covering the
// provided aSuperview.
//
// Parameters:
//    aSuperview - the superview that will be covered by the loading view
//
// returns the constructed view, already added as a subview of the aSuperview
//	(and hence retained by the superview)
//
+ (id)loadingViewInView:(UIView *)aSuperview
{
	SocializeLoadingView *loadingView =
	[[[SocializeLoadingView alloc] initWithFrame:[aSuperview bounds]] autorelease];
	
	if (!loadingView)
	{
		return nil;
	}
	
	loadingView.opaque = NO;
	loadingView.autoresizingMask =
	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:loadingView];
	
	UIActivityIndicatorView *activityIndicatorView =
	[[[UIActivityIndicatorView alloc]
	  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]
	 autorelease];
	[loadingView addSubview:activityIndicatorView];
	activityIndicatorView.autoresizingMask =
	UIViewAutoresizingFlexibleLeftMargin |
	UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin |
	UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
	
	CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x =
	0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y =
	0.5 * (loadingView.frame.size.height - activityIndicatorRect.size.height);
	activityIndicatorView.frame = activityIndicatorRect;
	
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	animation.duration = 0.18;
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
	
	loadingView.timestamp = [NSDate date];
	return loadingView;
}

//loading in view for our socialize stuff
+ (id)loadingViewInView:(UIView *)aSuperview withFrame:(CGRect)myrect andString:(NSString*)message
{
	SocializeLoadingView *loadingView =
	[[[SocializeLoadingView alloc] initWithFrame:myrect] autorelease];
	if (!loadingView)
	{
		return nil;
	}
	
	loadingView.opaque = NO;
	loadingView.autoresizingMask =
	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:loadingView];
	
	const CGFloat DEFAULT_LABEL_WIDTH = 0.0;
	const CGFloat DEFAULT_LABEL_HEIGHT = 0.0;
	CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
	UILabel *loadingLabel =
	[[[UILabel alloc]
	  initWithFrame:labelFrame]
	 autorelease];
	loadingLabel.text = message;
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textAlignment = NSTextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	loadingLabel.autoresizingMask =
	UIViewAutoresizingFlexibleLeftMargin |
	UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin |
	UIViewAutoresizingFlexibleBottomMargin;
	
	[loadingView addSubview:loadingLabel];
	UIActivityIndicatorView *activityIndicatorView =
	[[[UIActivityIndicatorView alloc]
	  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]
	 autorelease];
	[loadingView addSubview:activityIndicatorView];
	activityIndicatorView.autoresizingMask =
	UIViewAutoresizingFlexibleLeftMargin |
	UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin |
	UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
	
	CGFloat totalHeight =
	loadingLabel.frame.size.height +
	activityIndicatorView.frame.size.height;
	labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
	labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - totalHeight));
	loadingLabel.frame = labelFrame;
	
	CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x =
	0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y =
	loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
	activityIndicatorView.frame = activityIndicatorRect;
	
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
	
	loadingView.timestamp = [NSDate date];
	return loadingView;
}


//
// removeView
//
// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{
	UIView *aSuperview = [self superview];
	[super removeFromSuperview];
	
	// Set up the animation
	CATransition *animation = [CATransition animation];
	animation.duration = 0.18;
	[animation setType:kCATransitionFade];
	
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

//
// drawRect:
//
// Draw the view.
//

#define kINNER_RECT_HEIGHT  100
#define kINNER_RECT_WIDTH	100


- (void)drawRect:(CGRect)rect
{
	
	const CGFloat RECT_PADDING = 0.0;
	rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
	
	CGRect innerRect;
	innerRect.origin.x = floor(0.5 * (rect.size.width - kINNER_RECT_WIDTH));
	innerRect.origin.y = floor(0.5 * (rect.size.height - kINNER_RECT_HEIGHT));
	
	innerRect.size = CGSizeMake(kINNER_RECT_WIDTH, kINNER_RECT_HEIGHT);
	
	CGPathRef backgroundRectPath = NewPathWithRoundRect(rect, 0);
	CGPathRef innerRectPath  = NewPathWithRoundRect(innerRect, 8);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat BACKGROUND_OPACITY;
	
	BACKGROUND_OPACITY = 0.60;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, backgroundRectPath);
	CGContextFillPath(context);
	
	BACKGROUND_OPACITY = 0.85;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, innerRectPath);
	CGContextFillPath(context);
	
	CGPathRelease(backgroundRectPath);
	CGPathRelease(innerRectPath);
}

//
// dealloc
//
// Release instance memory.
//
- (void)dealloc
{
	if (timestamp)
		[timestamp release];
    [super dealloc];
}

@end

static char *kSocializeLoadingViewKey = "kSocializeLoadingViewKey";

@implementation UIViewController (SocializeLoadingView)

- (void)showSocializeLoadingViewInSubview:(UIView*)subview {
    if (subview == nil) {
        subview = self.view;
    }
    
    SocializeLoadingView *loading = [SocializeLoadingView loadingViewInView:subview];
    [self bk_associateValue:loading withKey:kSocializeLoadingViewKey];
}

- (void)hideSocializeLoadingView {
    UIView *view = [self bk_associatedValueForKey:kSocializeLoadingViewKey];
    [view removeFromSuperview];
}

@end
