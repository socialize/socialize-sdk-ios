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
#import "UIButton+SocializeIOS6.h"
#import "UIDevice+VersionCheck.h"

@implementation UIButton (Socialize)

//class cluster impl for legacy OS compatibility
+ (id)alloc {
    if([self class] == [UIButton class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [UIButtonIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

-(void)configureWithType:(AMSocializeButtonType)type {
    [self configureWithTitle:nil type:type];
}

-(void)configureWithoutResizingWithType:(AMSocializeButtonType)type {
    [self configureWithoutResizingWithTitle:nil type:type];
}

- (void)configureWithTitle:(NSString*)title {
    if ([title length] > 0) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    if ([self.titleLabel.text length] > 0) {
        CGSize buttonSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(100, 29)];
        self.bounds = CGRectMake(0, 0, buttonSize.width+20, 29);
    }
    else {
        self.bounds = CGRectMake(0, 0, 50, 29); 
    }
    
	self.titleLabel.layer.shadowOpacity = 1.0;
	self.titleLabel.layer.shadowRadius = 0.0;
	self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
	self.titleLabel.layer.shadowOffset = CGSizeMake(0, -1.0);
}

-(void)configureWithTitle:(NSString *)title type:(AMSocializeButtonType)type {
    UIColor * disabledColor = [UIColor colorWithRed:220.0/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [self setTitleColor:disabledColor forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleShadowColor:disabledColor forState:UIControlStateDisabled];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [self configureWithTitle:title];
}

-(void)configureWithoutResizingWithTitle:(NSString *)title type:(AMSocializeButtonType)type {
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)configureBackButtonWithTitle:(NSString *)title {
	self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	//the spacing in the string is need here so that it'll be centered when displayed
	NSString * titleString = [NSString stringWithFormat:@"  %@", title];
	[self setTitle:titleString forState:UIControlStateNormal];
	CGSize backButtonSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(100, 29)];
	
    self.frame = CGRectMake(0, 0, backButtonSize.width+25, 29);
	[self.titleLabel applyBlurAndShadowWithOffset:-1.0];
}

//in iOS7+ this will not be a particular color
+(UIButton *)redSocializeNavBarButton {
    return [UIButton redSocializeNavBarButtonWithTitle:nil];    
}

//in iOS7+ this will not be a particular color
+(UIButton *)redSocializeNavBarButtonWithTitle:(NSString *)title {
    UIButton * redButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redButton configureWithTitle:title type:AMSOCIALIZE_BUTTON_TYPE_RED];
    return redButton;
}

//in iOS7+ this will not be a particular color
+(UIButton *)blueSocializeNavBarButton {
    return [UIButton blueSocializeNavBarButtonWithTitle:nil];
}

//in iOS7+ this will not be a particular color
+(UIButton *)blueSocializeNavBarButtonWithTitle:(NSString *)title {
    UIButton * blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blueButton configureWithTitle:title type:AMSOCIALIZE_BUTTON_TYPE_BLUE];
    return  blueButton;
}

//in iOS7+ this will not be a particular color
+(UIButton *)blueSocializeNavBarBackButtonWithTitle:(NSString *)title {
	UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton configureBackButtonWithTitle:title];
    return backButton;
}

- (void)addSocializeRoundedGrayButtonImages {
    //does nothing in iOS7+
}

@end
