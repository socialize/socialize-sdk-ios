//
//  UIButton+Socialize.m
//  appbuildr
//
//  Created by William M. Johnson on 4/7/11.
//  Copyright 2011 pointabout. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Socialize.h"
#import "UILabel-Additions.h"

@implementation UIButton (Socialize)

-(void)configureWithType:(AMSocializeButtonType)type
{
    
    [self configureWithTitle:nil type:type];
}

-(void)configureWithoutResizingWithType:(AMSocializeButtonType)type
{
    
    [self configureWithoutResizingWithTitle:nil type:type];
}

-(void)configureWithTitle:(NSString *)title type:(AMSocializeButtonType)type
{
    NSString * normalImageURI = nil;
    NSString * highlightImageURI = nil;
    switch (type) 
    {
        case AMSOCIALIZE_BUTTON_TYPE_RED:
            normalImageURI = @"socialize-navbar-button-red.png";
            highlightImageURI = @"socialize-navbar-button-red-active.png";
            break;
        case AMSOCIALIZE_BUTTON_TYPE_BLUE:
            normalImageURI = @"socialize-navbar-button-blue-bg-normal.png";
            highlightImageURI = @"socialize-navbar-button-blue-bg-highlighted.png";
            break;
        case AMSOCIALIZE_BUTTON_TYPE_BLACK:
        default:
            normalImageURI = @"socialize-navbar-button-dark.png";
            highlightImageURI = @"socialize-navbar-button-dark-active.png";
            break;
    }
    
    UIImage * normalImage = [[UIImage imageNamed:normalImageURI]stretchableImageWithLeftCapWidth:6 topCapHeight:0] ;
    UIImage * highlightImage = [[UIImage imageNamed:highlightImageURI]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
	[self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    self.titleLabel.textColor = [UIColor whiteColor]; 
    
    if ([title length] > 0) 
    {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    
    if ([self.titleLabel.text length] > 0) 
    {
        CGSize buttonSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(100, 29)];
        self.bounds = CGRectMake(0, 0, buttonSize.width+20, 29);
    }
    else
    {
        self.bounds = CGRectMake(0, 0, 50, 29); 
    }

	self.titleLabel.layer.shadowOpacity = 1.0;
	self.titleLabel.layer.shadowRadius = 0.0;
	self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
	self.titleLabel.layer.shadowOffset = CGSizeMake(0, -1.0);
 
       
}

-(void)configureWithoutResizingWithTitle:(NSString *)title type:(AMSocializeButtonType)type
{
    NSString * normalImageURI = nil;
    NSString * highlightImageURI = nil;
    switch (type) 
    {
        case AMSOCIALIZE_BUTTON_TYPE_RED:
            normalImageURI = @"socialize-navbar-button-red.png";
            highlightImageURI = @"socialize-navbar-button-red-active.png";
            break;
        case AMSOCIALIZE_BUTTON_TYPE_BLUE:
            normalImageURI = @"socialize-navbar-button-blue-bg-normal.png";
            highlightImageURI = @"socialize-navbar-button-blue-bg-highlighted.png";
            break;
        case AMSOCIALIZE_BUTTON_TYPE_BLACK:
        default:
            normalImageURI = @"socialize-navbar-button-dark.png";
            highlightImageURI = @"socialize-navbar-button-dark-active.png";
            break;
    }
    
    UIImage * normalImage = [[UIImage imageNamed:normalImageURI]stretchableImageWithLeftCapWidth:6 topCapHeight:0] ;
    UIImage * highlightImage = [[UIImage imageNamed:highlightImageURI]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
	[self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
/* 
    self.titleLabel.textColor = [UIColor whiteColor]; 
    
    if ([title length] > 0) 
    {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    
    if ([self.titleLabel.text length] > 0) 
    {
        CGSize buttonSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(100, 29)];
        self.bounds = CGRectMake(0, 0, buttonSize.width+20, 29);
    }
    else
    {
        self.bounds = CGRectMake(0, 0, 50, 29); 
    }
    
	self.titleLabel.layer.shadowOpacity = 1.0;
	self.titleLabel.layer.shadowRadius = 0.0;
	self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
	self.titleLabel.layer.shadowOffset = CGSizeMake(0, -1.0);
*/
}




+(UIButton *)redSocializeNavBarButton
{
    return [UIButton redSocializeNavBarButtonWithTitle:nil];    
}

+(UIButton *)redSocializeNavBarButtonWithTitle:(NSString *)title
{
    UIButton * redButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redButton configureWithTitle:title type:AMSOCIALIZE_BUTTON_TYPE_RED];
    return  redButton;
}

+(UIButton *)blueSocializeNavBarButton
{
    return [UIButton blueSocializeNavBarButtonWithTitle:nil];
}

+(UIButton *)blueSocializeNavBarButtonWithTitle:(NSString *)title
{
    UIButton * blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blueButton configureWithTitle:title type:AMSOCIALIZE_BUTTON_TYPE_BLUE];
    return  blueButton;
}

+(UIButton *)blackSocializeNavBarButton
{
    return [UIButton blackSocializeNavBarButtonWithTitle:nil];
}

+(UIButton *)blackSocializeNavBarButtonWithTitle:(NSString *)title
{
    UIButton * blackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blackButton configureWithTitle:title type:AMSOCIALIZE_BUTTON_TYPE_BLACK];
    return  blackButton;
}

+(UIButton *)blueSocializeNavBarBackButtonWithTitle:(NSString *)title
{
    UIImage* backImageNormal = [[UIImage imageNamed:@"socialize-navbar-button-back.png"]stretchableImageWithLeftCapWidth:14 topCapHeight:0] ;
	UIImage* backImageHighligted = [[UIImage imageNamed:@"socialize-navbar-button-back-pressed.png"]stretchableImageWithLeftCapWidth:14 topCapHeight:0];
	UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[backButton setBackgroundImage:backImageNormal forState:UIControlStateNormal];
	[backButton setBackgroundImage:backImageHighligted forState:UIControlStateHighlighted];
	backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	
	NSString * titleString = [NSString stringWithFormat:@"  %@", title];
	[backButton setTitle:titleString forState:UIControlStateNormal];
	CGSize backButtonSize = [backButton.titleLabel.text sizeWithFont:backButton.titleLabel.font constrainedToSize:CGSizeMake(100, 29)];
	
    backButton.frame = CGRectMake(0, 0, backButtonSize.width+25, 29);
	[backButton.titleLabel applyBlurAndShadowWithOffset:-1.0];
    return  backButton;
}


@end
