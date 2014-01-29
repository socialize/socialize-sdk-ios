//
//  UIButton+Socialize.h
//  appbuildr
//
//  Created by William M. Johnson on 4/7/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum 
{
	AMSOCIALIZE_BUTTON_TYPE_RED,
	AMSOCIALIZE_BUTTON_TYPE_BLUE,
    AMSOCIALIZE_BUTTON_TYPE_BLACK
}AMSocializeButtonType;

@interface UIButton (Socialize)

-(void)configureWithTitle:(NSString *)title type:(AMSocializeButtonType)type;
-(void)configureWithoutResizingWithTitle:(NSString *)title type:(AMSocializeButtonType)type;
-(void)configureWithType:(AMSocializeButtonType)type;
-(void)configureWithoutResizingWithType:(AMSocializeButtonType)type;
- (void)addSocializeRoundedGrayButtonImages;
- (void)configureWithTitle:(NSString*)title;
- (void)configureBackButtonWithTitle:(NSString *)title;

+(UIButton *)redSocializeNavBarButton;
+(UIButton *)redSocializeNavBarButtonWithTitle:(NSString *)title;

+(UIButton *)blueSocializeNavBarButton;
+(UIButton *)blueSocializeNavBarButtonWithTitle:(NSString *)title;

+(UIButton *)blueSocializeNavBarBackButtonWithTitle:(NSString *)title;
@end
