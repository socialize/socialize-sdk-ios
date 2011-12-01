//
//  UINavigationBarBackground.h
//  appbuildr
//
//  Created by Isaac Mosquera on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern const NSInteger UINavigationBarBackgroundImageTag;

@interface UINavigationBar(UINavigationBarCategory) 
- (void)setBackgroundImage:(UIImage*)image;
- (void)showBackgroundImage;
- (void)hideBackgroundImage;
- (UIImage*)backgroundImage;

-(void)setBackgroundImage:(UIImage*)image withTag:(NSInteger)bgTag;
-(void)removeBackgroundWithTag:(NSInteger)bgTag;
-(void)resetBackground;
@end
