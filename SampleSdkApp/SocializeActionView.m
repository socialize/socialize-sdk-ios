//
//  SocializeActionView.m
//  appbuildr
//
//  Created by Fawad Haider  on 12/9/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import "SocializeActionView.h"
#import "NSNumber+Additions.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor \
	colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
		green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
			blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ACTION_VIEW_WIDTH 320
#define BUTTON_PADDINGS 4
#define ICON_WIDTH 16
#define ICON_HEIGHT 16
#define BUTTON_HEIGHT 30
#define BUTTON_Y_ORIGIN 7
#define PADDING_IN_BETWEEN_BUTTONS 10
#define COMMENT_INDICATOR_SIZE_WIDTH 17
#define COMMENT_INDICATOR_SIZE_HEIGHT 17
#define PADDING_BETWEEN_TEXT_ICON 2

@interface SocializeActionView()

-(void)setupButtons;
-(void)setButtonLabel:(NSString*)labelString 
		withImageForNormalState:(NSString*)bgImage 
		withImageForHightlightedState:(NSString*)bgHighlightedImage 
		withIconName:(NSString*)iconName
		atOrigin:(CGPoint)frameOrigin 
		onButton:(UIButton*)button
		withSelector:(SEL)selector;
-(CGSize)getButtonSizeForLabel:(NSString*)labelString iconName:(NSString*)iconName;

-(void)commentButtonPressed:(id)sender;
-(void)likeButtonPressed:(id)sender;
-(void)shareButtonPressed:(id)sender;

@end

@implementation SocializeActionView

@synthesize delegate = _socializeDelegate;
@synthesize isLiked = _isLiked;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_buttonLabelFont = [[UIFont boldSystemFontOfSize:11.0f] retain];
        self.delegate = nil;
	
		[self setupButtons];
	}
    return self;
}

-(void)setupButtons 
{
	CGPoint buttonOrigin;
	CGSize buttonSize;

	_shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
	buttonSize = [self getButtonSizeForLabel:@"Share" iconName:@"action-bar-icon-share.png"];
	buttonOrigin.x = ACTION_VIEW_WIDTH - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
	
	[self setButtonLabel:@"Share" 
			withImageForNormalState: @"action-bar-button-black.png" 
			withImageForHightlightedState:@"action-bar-button-black-hover.png"
			withIconName:@"action-bar-icon-share.png"
			atOrigin:buttonOrigin
			onButton:_shareButton
			withSelector:@selector(shareButtonPressed:)];
	[self addSubview:_shareButton];
	
	_commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
	buttonSize = [self getButtonSizeForLabel:nil iconName:@"comment-sm-icon.png"];
	buttonOrigin.x = buttonOrigin.x - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
	
	[self setButtonLabel:nil 
			withImageForNormalState: @"action-bar-button-black.png" 
			withImageForHightlightedState:@"action-bar-button-black-hover.png"
			withIconName:@"action-bar-icon-comments.png"
				atOrigin:buttonOrigin
				onButton:_commentButton
			withSelector:@selector(commentButtonPressed:)];
	
	[self addSubview:_commentButton];

	_likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	buttonSize = [self getButtonSizeForLabel:nil iconName:@"action-bar-icon-like.png"];
	buttonOrigin.x = buttonOrigin.x - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN; 
	
	if (_isLiked){
		[self setButtonLabel:nil 
			withImageForNormalState: @"action-bar-button-red.png" 
				withImageForHightlightedState:@"action-bar-button-red-hover.png"
				withIconName:@"action-bar-icon-liked.png"
					atOrigin:buttonOrigin
					onButton:_likeButton
				withSelector:@selector(likeButtonPressed:)];
	}
	else {
		[self setButtonLabel:nil 
			withImageForNormalState: @"action-bar-button-black.png" 
			withImageForHightlightedState:@"action-bar-button-black-hover.png"
				withIconName:@"action-bar-icon-like.png"
					atOrigin:buttonOrigin
					onButton:_likeButton
				withSelector:@selector(likeButtonPressed:)];
	}

	[self addSubview:_likeButton];
 	_viewCounter = [UIButton buttonWithType:UIButtonTypeCustom];
	_viewCounter.userInteractionEnabled = NO;
	_viewCounter.hidden = YES;

	buttonOrigin.x = PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
	[self setButtonLabel:nil 
		withImageForNormalState: nil 
		withImageForHightlightedState:nil
			withIconName:@"action-bar-icon-views.png"
				atOrigin:buttonOrigin
				onButton:_viewCounter
			withSelector:nil];
	[self addSubview:_viewCounter];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(buttonOrigin.x, buttonOrigin.y + 5, 20, 20)];
	[self addSubview:_activityIndicator];
	[_activityIndicator startAnimating];
}

- (CGSize)getButtonSizeForLabel:(NSString*)labelString iconName:(NSString*)iconName 
{
	if ([labelString length] <= 0)
	{
		return CGSizeZero;
	}
	
	CGSize labelSize = [labelString sizeWithFont:_buttonLabelFont];
	if (iconName)
		labelSize = CGSizeMake(labelSize.width + (2 * BUTTON_PADDINGS) + PADDING_BETWEEN_TEXT_ICON + 5 + ICON_WIDTH, BUTTON_HEIGHT);
	else
		labelSize = CGSizeMake(labelSize.width + (2 * BUTTON_PADDINGS), BUTTON_HEIGHT);
	
	return labelSize;
}

- (void) updateCountsWithViewsCount:(NSNumber*) viewsCount withLikesCount: (NSNumber*) likesCount withCommentsCount: (NSNumber*) commentsCount
{
	[UIView beginAnimations:@"adjustActionBar" context:nil];
    
    CGPoint buttonOrigin;
	CGSize buttonSize;
		
	buttonSize = [self getButtonSizeForLabel:@"Share" iconName:@"action-bar-icon-share.png"];
	buttonOrigin.x = ACTION_VIEW_WIDTH - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
	_shareButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
	[_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON)]; // Left inset is the negative of image width.
	[_shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
		
	NSString* formattedValue = [NSNumber formatMyNumber:commentsCount ceiling:[NSNumber numberWithInt:1000]];

	buttonSize = [self getButtonSizeForLabel:formattedValue  iconName:@"comment-sm-icon.png"];
	buttonOrigin.x = buttonOrigin.x - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
	[_commentButton setTitle:formattedValue forState:UIControlStateNormal] ;
	_commentButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
	[_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON)]; // Left inset is the negative of image width.
	[_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.

	formattedValue = [NSNumber formatMyNumber:likesCount ceiling:[NSNumber numberWithInt:1000]]; 

	buttonSize = [self getButtonSizeForLabel:formattedValue iconName:@"likes-sm-icon.png"];
	buttonOrigin.x = buttonOrigin.x - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
	[_likeButton setTitle:formattedValue forState:UIControlStateNormal] ;
	if (_isLiked){
		[_likeButton setBackgroundImage:[UIImage imageNamed:@"action-bar-button-red.png"] forState:UIControlStateNormal]; 
		[_likeButton setBackgroundImage:[UIImage imageNamed:@"action-bar-button-red-hover.png"] forState: UIControlStateHighlighted]; 
		[_likeButton setImage:[UIImage imageNamed:@"action-bar-icon-liked.png"] forState:UIControlStateNormal];
		[_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
    }
	else{
		[_likeButton setBackgroundImage:[UIImage imageNamed:@"action-bar-button-black.png"] forState:UIControlStateNormal]; 
		[_likeButton setBackgroundImage:[UIImage imageNamed:@"action-bar-button-black-hover.png"] forState:UIControlStateHighlighted]; 
		[_likeButton setImage:[UIImage imageNamed:@"action-bar-icon-like.png"] forState:UIControlStateNormal];
		[_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
    }
	[_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
	_likeButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
	[_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON)]; // Left inset is the negative of image width.
		
	[_activityIndicator stopAnimating];
	[_activityIndicator removeFromSuperview];
		
	formattedValue = [NSNumber formatMyNumber:viewsCount ceiling:[NSNumber numberWithInt:10000000]];

	buttonSize = [self getButtonSizeForLabel:formattedValue iconName:@"view-sm-icon.png"];
	buttonOrigin.x = PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;

	[_viewCounter setTitle:formattedValue forState:UIControlStateNormal];
	_viewCounter.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
	[_viewCounter setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON - 2)]; // Left inset is the negative of image width.
	[_viewCounter setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
	_viewCounter.hidden = NO;
	[UIView commitAnimations];
}


-(void)setButtonLabel:(NSString*)labelString 
		withImageForNormalState:(NSString*)bgImage 
		withImageForHightlightedState:(NSString*)bgHighlightedImage 
		withIconName:(NSString*)iconName
			 atOrigin:(CGPoint)frameOrigin 
			 onButton:(UIButton*)button
		 withSelector:(SEL)selector 
{
	CGSize buttonSize = [self getButtonSizeForLabel:labelString iconName:iconName];

	if (iconName)
		button.frame =  CGRectMake(frameOrigin.x, frameOrigin.y , buttonSize.width , buttonSize.height);
	else
		button.frame =  CGRectMake(frameOrigin.x, frameOrigin.y , buttonSize.width , buttonSize.height);
	
	UIImage* imageForNormalState = [[UIImage imageNamed:bgImage] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
	UIImage* imageForHighlightedState = [[UIImage imageNamed:bgHighlightedImage] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
	
	[button setBackgroundImage:imageForNormalState forState:UIControlStateNormal]; 
	[button setBackgroundImage:imageForHighlightedState forState:UIControlStateHighlighted]; 
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	
	// Now load the image and create the image view
	if (iconName){
		UIImage *image = [UIImage imageNamed:iconName];
		[button setImage:image forState:UIControlStateNormal];
		[button setImageEdgeInsets:UIEdgeInsetsMake(0, 0.0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
	}
	
	// Create the label and set its text
	[button.titleLabel setFont:_buttonLabelFont];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.titleLabel.shadowColor = [UIColor blackColor]; 
	button.titleLabel.shadowOffset = CGSizeMake(0, -1); 
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, 0.0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
	if (labelString){
		[button setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
		[button setTitle:labelString forState:UIControlStateNormal];
		[button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON)]; // Left inset is the negative of image width.
	}
	else 
		[button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0)]; // Left inset is the negative of image width.
}

#pragma mark Socialize Delegate

-(void)commentButtonPressed:(id)sender
{
    //newCommentMarker.hidden = YES;
	[_socializeDelegate commentButtonTouched:sender];
}	

-(void)likeButtonPressed:(id)sender
{
	[_socializeDelegate likeButtonTouched:sender];
}

-(void)shareButtonPressed:(id)sender
{
	[_socializeDelegate shareButtonTouched:sender];
}

#pragma -
- (void)drawRect:(CGRect)rect 
{	
	[super drawRect:rect];
	[[[UIImage imageNamed:@"action-bar-bg.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5] 
			drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
					blendMode:kCGBlendModeMultiply alpha:1.0];
}


- (void)dealloc 
{
    [_commentButton release]; _commentButton = nil;
	[_likeButton release]; _likeButton = nil;
	[_shareButton release]; _shareButton = nil;
	[_viewCounter release]; _viewCounter = nil;
    [_buttonLabelFont release]; _buttonLabelFont = nil;
    [_activityIndicator release]; _activityIndicator = nil;

    [super dealloc];
}

@end
