//
//  UINavigationBarBackground.m
//  appbuildr
//
//  Created by Isaac Mosquera on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBarBackground.h"

const NSInteger UINavigationBarBackgroundImageTag = 1234;


@implementation UINavigationBar (UINavigationBarCategory)

- (void)setBackgroundImage:(UIImage*)image
{
	[self setBackgroundImage:(UIImage*)image withTag:UINavigationBarBackgroundImageTag];
	[self resetBackground];
}

- (void)showBackgroundImage
{
	UIView *view = [self viewWithTag:UINavigationBarBackgroundImageTag];
	if( view ) 
	{
		view.hidden = NO;
		
	}
	[self resetBackground];
}

- (void)hideBackgroundImage
{
	UIView *view = [self viewWithTag:UINavigationBarBackgroundImageTag];
	if( view ) 
	{
		view.hidden = YES;
	}
}

- (UIImage*)backgroundImage {
    if ([UINavigationBar instancesRespondToSelector:@selector(backgroundImage:forBarMetrics:)]) {
        return [self backgroundImageForBarMetrics:UIBarMetricsDefault];
    } else {
        UIImageView *imageView = (UIImageView*)[self viewWithTag:UINavigationBarBackgroundImageTag];
        return imageView.image;
    }
}

- (void)setBackgroundImage:(UIImage*)image withTag:(NSInteger)bgTag{

	if(image == nil){ //might be called with NULL argument
		return;
	}

    if ([UINavigationBar instancesRespondToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        if( [self viewWithTag: UINavigationBarBackgroundImageTag] ) {   
            //there is already a tag with this view so we're exiting this function.
            return;
        }
        
        UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
        aTabBarBackground.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        self.translucent = NO;
        aTabBarBackground.tag = bgTag;
        aTabBarBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth; // Resizes image during rotation
        
        [self addSubview:aTabBarBackground];
        [self sendSubviewToBack:aTabBarBackground];
        [aTabBarBackground release];
    }
}

-(void)removeBackgroundWithTag:(NSInteger)bgTag {
	UIView *view = [self viewWithTag:bgTag];
	if( view ) {
		[view removeFromSuperview];
	}
}

-(void)resetBackground {
	[self sendSubviewToBack:[self viewWithTag:UINavigationBarBackgroundImageTag]];
}


@end

