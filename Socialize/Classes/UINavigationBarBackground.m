//
//  UINavigationBarBackground.m
//  appbuildr
//
//  Created by Isaac Mosquera on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBarBackground.h"

static const NSInteger navBgTag = 1234;
BOOL useBackgroundImage = NO;


@implementation UINavigationBar (UINavigationBarCategory)

- (void)setBackgroundImage:(UIImage*)image
{
	[self setBackgroundImage:(UIImage*)image withTag:navBgTag];
	[self resetBackground:navBgTag];
	
}

- (void)showBackgroundImage
{
	UIView *view = [self viewWithTag:navBgTag];
	if( view ) 
	{
		view.hidden = NO;
		
	}
	else 
	{
		if (useBackgroundImage)
		{
			
			[self setBackgroundImage:[UIImage imageNamed:@"header_image.png"] withTag:navBgTag];
		}
	}

	[self resetBackground:navBgTag];
}

- (void)hideBackgroundImage
{
	UIView *view = [self viewWithTag:navBgTag];
	if( view ) 
	{
		view.hidden = YES;
	}
}

- (void)setBackgroundImage:(UIImage*)image withTag:(NSInteger)bgTag{

	if(image == nil){ //might be called with NULL argument
		return;
	}
	if( [self viewWithTag: 1234] ) {
		//there is already a tag with this view so we're exiting this function.
		return;
	}
	
	UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
	aTabBarBackground.frame = CGRectMake(0, 0, 320, self.frame.size.height);
    
	self.translucent = NO;
	aTabBarBackground.tag = bgTag;
	aTabBarBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight; // Resizes image during rotation
    
	[self addSubview:aTabBarBackground];
	[self sendSubviewToBack:aTabBarBackground];
	[aTabBarBackground release];

}

-(void)removeBackgroundWithTag:(NSInteger)bgTag {
	UIView *view = [self viewWithTag:bgTag];
	if( view ) {
		[view removeFromSuperview];
	}
}
-(void)resetBackground:(NSInteger)bgTag {
	[self sendSubviewToBack:[self viewWithTag:bgTag]];
}
@end

