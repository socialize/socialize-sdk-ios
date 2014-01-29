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

int const SocializeButtonFontSize = 16;
int const SocializeButtonWidth = 100;
int const SocializeButtonHeight = 31;
int const SocializeButtonPadding = 5;

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
        self.titleLabel.font = [UIFont boldSystemFontOfSize:SocializeButtonFontSize];
    }
    
    if ([self.titleLabel.text length] > 0) {
        CGSize buttonSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                             constrainedToSize:CGSizeMake(SocializeButtonWidth, SocializeButtonHeight)];
        self.bounds = CGRectMake(0, 0, buttonSize.width+SocializeButtonPadding, SocializeButtonHeight);
    }
    else {
        self.bounds = CGRectMake(0, 0, SocializeButtonWidth/2, SocializeButtonHeight);
    }
}

-(void)configureWithTitle:(NSString *)title type:(AMSocializeButtonType)type {
    [self configureWithoutResizingWithTitle:title type:type];
    [self configureWithTitle:title];
}

-(void)configureWithoutResizingWithTitle:(NSString *)title type:(AMSocializeButtonType)type {
    //ShareThis gray
    UIColor *disabledColor = [UIColor colorWithRed:187.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    //ShareThis med gray
    UIColor *highlightColor = [UIColor colorWithRed:71.0/255.0 green:84.0/255.0 blue:93.0/255.0 alpha:1.0];
    [self setTitleColor:disabledColor forState:UIControlStateDisabled];
    [self setTitleColor:highlightColor forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleShadowColor:disabledColor forState:UIControlStateDisabled];
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)configureBackButtonWithTitle:(NSString *)title {
    //This defaults to iOS 7 look; for earlier iOS versions, see class cluster variants
    UIImage *backImage = [UIImage imageNamed:@"socialize-navbar-button-back-ios7.png"];
    [self setImage:backImage forState:UIControlStateNormal];

    self.titleLabel.font = [UIFont boldSystemFontOfSize:SocializeButtonFontSize];

    //a crude yet effective way to insert a bit of padding before the image
    NSString * titleString = [NSString stringWithFormat:@"  %@", title];
	[self setTitle:titleString forState:UIControlStateNormal];
    [self configureWithoutResizingWithTitle:title type:nil];
	CGSize backButtonSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                             constrainedToSize:CGSizeMake(SocializeButtonWidth, SocializeButtonHeight)];
	
    self.frame = CGRectMake(0, 0, backButtonSize.width+backImage.size.width, SocializeButtonHeight);
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
