//
//  SZLinkDialogView.m
//  Socialize
//
//  Created by David Jedeikin on 10/21/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZLinkDialogView.h"
#import "UITableView+Resize.h"

@interface SZLinkDialogView() {
    int topImageIndex;
    float topImageHeight;
}
@end

@implementation SZLinkDialogView


@synthesize topImageView;

//A bit of smarts around landscape resizing
- (void)layoutSubviews {
    UITableView *tableView = nil;
    
    //cache these values
    topImageIndex = [self.subviews indexOfObject:self.topImageView];
    topImageHeight = self.topImageView.frame.size.height;
    
    // Hide upper image on phone, in landscape
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) &&
        [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if(self.topImageView && [self.topImageView superview]) {
            //remove image from view
            [self.topImageView removeFromSuperview];
            //move all other images up
            for (UIView *subview in self.subviews) {
                if([subview isKindOfClass:[UITableView class]] && !tableView) {
                    tableView = (UITableView *)subview;
                }
                
                CGRect subViewFrame = subview.frame;
                [subview setFrame:CGRectMake(subViewFrame.origin.x,
                                             subViewFrame.origin.y - topImageHeight - 20,
                                             subViewFrame.size.width,
                                             subViewFrame.size.height)];
            }
            if (tableView && [tableView numberOfSections] > 0) {
                [tableView sizeToCells];
            }
        }
    }
    //back in portrait mode, needs view put back and offsets removed
    else if(![self.topImageView superview]) {
        [self insertSubview:self.topImageView atIndex:topImageIndex];
        CGRect topImageFrame = self.topImageView.frame;
        
        //calculate center point
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenBounds.size.width;
        CGFloat imagewidth = self.topImageView.frame.size.width;
        CGFloat topImageOrigin = (screenWidth / 2) - (imagewidth / 2);
        
        [self.topImageView setFrame:CGRectMake(topImageOrigin,
                                               topImageFrame.origin.y,
                                               topImageFrame.size.width,
                                               topImageHeight)];
        //move all other images down
        for (UIView *subview in self.subviews) {
            //skip this one
            if(subview == self.topImageView) {
                continue;
            }
            CGRect subViewFrame = subview.frame;
            [subview setFrame:CGRectMake(subViewFrame.origin.x,
                                         subViewFrame.origin.y + topImageHeight + 20,
                                         subViewFrame.size.width,
                                         subViewFrame.size.height)];
        }
    }
    
    [super layoutSubviews];
}

@end
