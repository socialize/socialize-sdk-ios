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
-(void)instantiateButtons;
-(void)setupButtons;
-(void)setButtonLabel:(NSString*)labelString 
		withImageForNormalState:(NSString*)bgImage 
		withImageForHightlightedState:(NSString*)bgHighlightedImage 
		withIconName:(NSString*)iconName
		atOrigin:(CGPoint)frameOrigin 
		onButton:(UIButton*)button
		withSelector:(SEL)selector;
-(CGSize)getButtonSizeForLabel:(NSString*)labelString iconName:(NSString*)iconName;
@end

@implementation SocializeActionView

@synthesize delegate = _socializeDelegate;
@synthesize isLiked = _isLiked;
@synthesize noAutoLayout = _noAutoLayout;

//@synthesize commentButton = _commentButton, likeButton = _likeButton, viewButton = _viewCounter, activityIndicator = _activityIndicator, buttonLabelFont = _buttonLabelFont;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.delegate = nil;
        [self instantiateButtons];
        [self setupButtons];
        self.accessibilityLabel = @"Socialize Action View";
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame labelButtonFont:(UIFont*)labelFont likeButton:(UIButton*)likeButton viewButton:(UIButton*)viewButton commentButton:(UIButton*)commentButton activityIndicator:(UIActivityIndicatorView*)activityIndicator{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = nil;
        _buttonLabelFont = [labelFont retain];
        _commentButton = [commentButton retain];
        _likeButton = [likeButton retain];
        _viewCounter = [viewButton retain];
        _activityIndicator = [activityIndicator retain];
        // TODO add share btn
		[self setupButtons];
        self.accessibilityLabel = @"Socialize Action View";
	}   
    return self;

}

-(void)instantiateButtons{
    _buttonLabelFont = [[UIFont boldSystemFontOfSize:11.0f] retain];
    _commentButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _commentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _likeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _likeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _viewCounter = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _viewCounter.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _shareButton = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
    _shareButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    
    _likeButton.accessibilityLabel = @"like button";
    _viewCounter.accessibilityLabel = @"view counter";
    _commentButton.accessibilityLabel = @"comment button";

}

-(void)setupButtons {
    
	CGPoint buttonOrigin;
	CGSize buttonSize;

	buttonSize = [self getButtonSizeForLabel:@"Share" iconName:@"action-bar-icon-share.png"];
	buttonOrigin.x = self.bounds.size.width - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
	
    [self setButtonLabel:@"Share" 
            withImageForNormalState: @"action-bar-button-black.png" 
            withImageForHightlightedState:@"action-bar-button-black-hover.png"
			withIconName:@"action-bar-icon-share.png"
                atOrigin:buttonOrigin
                onButton:_shareButton
			withSelector:@selector(shareButtonPressed:)];
    
    
	[self addSubview:_shareButton];
    
    buttonSize = [self getButtonSizeForLabel:@"0" iconName:@"comment-sm-icon.png"];
	buttonOrigin.x = buttonOrigin.x - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
 
	[self setButtonLabel:@"0" 
			withImageForNormalState: @"action-bar-button-black.png" 
			withImageForHightlightedState:@"action-bar-button-black-hover.png"
			withIconName:@"action-bar-icon-comments.png"
			atOrigin:buttonOrigin
			onButton:_commentButton
			withSelector:@selector(commentButtonPressed:)];
    
	[self addSubview:_commentButton];

	buttonSize = [self getButtonSizeForLabel:@"0" iconName:@"action-bar-icon-like.png"];
	buttonOrigin.x = buttonOrigin.x - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN; 
	
	[self setButtonLabel:@"0" 
          withImageForNormalState: @"action-bar-button-black.png" 
		  withImageForHightlightedState:@"action-bar-button-black-hover.png"
		  withIconName:@"action-bar-icon-like.png"
		  atOrigin:buttonOrigin
		  onButton:_likeButton
		  withSelector:@selector(likeButtonPressed:)];

	[self addSubview:_likeButton];
        
	_viewCounter.userInteractionEnabled = YES;
	_viewCounter.hidden = YES;

	buttonOrigin.x = PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
	
    [self setButtonLabel:@"0" 
		withImageForNormalState: nil 
		withImageForHightlightedState:nil
			withIconName:@"action-bar-icon-views.png"
				atOrigin:buttonOrigin
				onButton:_viewCounter
			withSelector:@selector(viewButtonPressed:)];
	[self addSubview:_viewCounter];
	
    _activityIndicator.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y + 5, 20, 20);
	[self addSubview:_activityIndicator];
	[_activityIndicator startAnimating];
}

- (UIImage*)buttonBackgroundImage:(NSString*)imageName {
    return [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
}

- (CGSize)getButtonSizeForLabel:(NSString*)labelString iconName:(NSString*)iconName 
{
	CGSize labelSize;
    /* NG -- commenting because the flow here does not make sense
	if ([labelString length] <= 0)
	{
		labelSize = CGSizeZero;
	}
     */
	
	labelSize = [labelString sizeWithFont:_buttonLabelFont];
	if (iconName)
		labelSize = CGSizeMake(labelSize.width + (2 * BUTTON_PADDINGS) + PADDING_BETWEEN_TEXT_ICON + 5 + ICON_WIDTH, BUTTON_HEIGHT);
	else
		labelSize = CGSizeMake(labelSize.width + (2 * BUTTON_PADDINGS), BUTTON_HEIGHT);
	
	return labelSize;
}

- (void) updateCountsWithViewsCount:(NSNumber*) viewsCount withLikesCount: (NSNumber*) likesCount isLiked: (BOOL)liked withCommentsCount: (NSNumber*) commentsCount
{
	[UIView beginAnimations:@"adjustActionBar" context:nil];
    
    [self updateCommentsCount:commentsCount];
    [self updateLikesCount:likesCount liked:liked];
		
	[_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
	
	[self updateViewsCount:viewsCount];
	_viewCounter.hidden = NO;
    
	[UIView commitAnimations];
}

- (void) updateViewsCount:(NSNumber*) viewsCount
{
    NSString* formattedValue = [NSNumber formatMyNumber:viewsCount ceiling:[NSNumber numberWithInt:10000000]];
    
	CGSize buttonSize = [self getButtonSizeForLabel:formattedValue iconName:@"view-sm-icon.png"];
	CGPoint buttonOrigin;
    buttonOrigin.x = PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
    
	[_viewCounter setTitle:formattedValue forState:UIControlStateNormal];
//    _viewCounter.accessibilityValue= formattedValue;
	_viewCounter.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
	[_viewCounter setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON - 2)]; // Left inset is the negative of image width.
	[_viewCounter setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
    
    _viewCounter.hidden = NO;
    [_activityIndicator stopAnimating];
}


- (void) updateIsLiked: (BOOL)isLiked{
    _isLiked = isLiked;
	if (_isLiked){
		[_likeButton setBackgroundImage:[self buttonBackgroundImage:@"action-bar-button-red.png"] forState:UIControlStateNormal]; 
		[_likeButton setBackgroundImage:[self buttonBackgroundImage:@"action-bar-button-red-hover.png"] forState: UIControlStateHighlighted]; 
		[_likeButton setImage:[UIImage imageNamed:@"action-bar-icon-liked.png"] forState:UIControlStateNormal];
		[_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
    }
	else{
		[_likeButton setBackgroundImage:[self buttonBackgroundImage:@"action-bar-button-black.png"] forState:UIControlStateNormal]; 
		[_likeButton setBackgroundImage:[self buttonBackgroundImage:@"action-bar-button-black-hover.png"] forState:UIControlStateHighlighted]; 
		[_likeButton setImage:[UIImage imageNamed:@"action-bar-icon-like.png"] forState:UIControlStateNormal];
		[_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
    }
}

- (void) updateLikesCount:(NSNumber*) likesCount liked: (BOOL)isLiked
{
    NSString* formattedValue = [NSNumber formatMyNumber:likesCount ceiling:[NSNumber numberWithInt:1000]]; 
    
	CGSize buttonSize = [self getButtonSizeForLabel:formattedValue iconName:@"likes-sm-icon.png"];
    CGPoint buttonOrigin = _commentButton.frame.origin;
	buttonOrigin.x = buttonOrigin.x - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
    
    _isLiked = isLiked;
	[_likeButton setTitle:formattedValue forState:UIControlStateNormal] ;
	if (_isLiked){
		[_likeButton setBackgroundImage:[self buttonBackgroundImage:@"action-bar-button-red.png"] forState:UIControlStateNormal]; 
		[_likeButton setBackgroundImage:[self buttonBackgroundImage:@"action-bar-button-red-hover.png"] forState: UIControlStateHighlighted]; 
		[_likeButton setImage:[UIImage imageNamed:@"action-bar-icon-liked.png"] forState:UIControlStateNormal];
		[_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
    }
	else{
		[_likeButton setBackgroundImage:[self buttonBackgroundImage:@"action-bar-button-black.png"] forState:UIControlStateNormal]; 
		[_likeButton setBackgroundImage:[self buttonBackgroundImage:@"action-bar-button-black-hover.png"] forState:UIControlStateHighlighted]; 
		[_likeButton setImage:[UIImage imageNamed:@"action-bar-icon-like.png"] forState:UIControlStateNormal];
		[_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
    }
    
	[_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
	_likeButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
	[_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON)]; // Left inset is the negative of image width.
}

- (void) updateCommentsCount:(NSNumber*) commentsCount
{
    NSString* formattedValue = [NSNumber formatMyNumber:commentsCount ceiling:[NSNumber numberWithInt:1000]];
	CGSize buttonSize = [self getButtonSizeForLabel:formattedValue  iconName:@"comment-sm-icon.png"];

    CGPoint buttonOrigin = _shareButton.frame.origin;

	buttonOrigin.x = buttonOrigin.x - buttonSize.width - PADDING_IN_BETWEEN_BUTTONS; 
	buttonOrigin.y = BUTTON_Y_ORIGIN;
    
	[_commentButton setTitle:formattedValue forState:UIControlStateNormal] ;
	_commentButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
	[_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -PADDING_BETWEEN_TEXT_ICON)]; // Left inset is the negative of image width.
	[_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0.0, 0.0)]; // Right inset is the negative of text bounds width.
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
 
	
	UIImage* imageForNormalState = [self buttonBackgroundImage:bgImage];;
	UIImage* imageForHighlightedState = [self buttonBackgroundImage:bgHighlightedImage];
	
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

- (void)lockButtons
{
    _likeButton.enabled = NO;
    _commentButton.enabled = NO;    
}
- (void)unlockButtons
{
    _likeButton.enabled = YES;
    _commentButton.enabled = YES;
}

- (void)hideButtons {
    _likeButton.hidden = YES;
    _commentButton.hidden = YES;
    _shareButton.hidden = YES;
}

- (void)showButtons {
    _likeButton.hidden = NO;
    _commentButton.hidden = NO;
    _shareButton.hidden = NO;
}

#pragma mark Socialize Delegate

-(void)commentButtonPressed:(id)sender
{
    [_socializeDelegate commentButtonTouched:sender];
}	

-(void)likeButtonPressed:(id)sender
{
	[_socializeDelegate likeButtonTouched:sender];
}

-(void)viewButtonPressed:(id)sender
{
	[_socializeDelegate viewButtonTouched:sender];
}

-(void)shareButtonPressed:(id)sender
{
	[_socializeDelegate shareButtonTouched:sender];
}


#pragma mark -
- (void)drawRect:(CGRect)rect 
{	
	[super drawRect:rect];   
	[[[UIImage imageNamed:@"action-bar-bg.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5] 
     drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
     blendMode:kCGBlendModeMultiply alpha:1.0];
}

- (void)positionInSuperview {
    [super setFrame:CGRectMake(0, self.superview.bounds.size.height - SOCIALIZE_ACTION_PANE_HEIGHT, self.superview.bounds.size.width,  SOCIALIZE_ACTION_PANE_HEIGHT)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_noAutoLayout) {
        [self positionInSuperview];
    }
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

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

- (void)startActivityForUpdateViewsCount {
    _viewCounter.hidden = YES;
    [_activityIndicator startAnimating];
}

- (void)dealloc 
{    
    [_commentButton release]; _commentButton = nil;
	[_likeButton release]; _likeButton = nil;
	[_viewCounter release]; _viewCounter = nil;
    [_buttonLabelFont release]; _buttonLabelFont = nil;
    [_activityIndicator release]; _activityIndicator = nil;

    [super dealloc];
}

@end
