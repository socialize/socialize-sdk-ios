//
//  CommentsTableFooterView.m
//  appbuildr
//
//  Created by Fawad Haider  on 1/13/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CommentsTableFooterView.h"
#import "UIDevice+VersionCheck.h"
#import "CommentsTableFooterViewIOS6.h"

@implementation CommentsTableFooterView

@synthesize backgroundImageView;
@synthesize searchBarImageView;
@synthesize addCommentButton;
@synthesize addCommentView = addCommentView_;
@synthesize subscribedButton = _subscribedButton;

//class cluster for iOS 6 compatibility
+ (id)alloc {
    if([self class] == [CommentsTableFooterView class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [CommentsTableFooterViewIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

//sets os version-appropriate background images
- (void)layoutSubviews{
    self.searchBarImageView.image = [[self searchBarImage] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    self.backgroundImageView.image = [self backgroundImage];
}

- (UIImage *)searchBarImage {
    return [UIImage imageNamed:@"socialize-comment-background-text-input-ios7.png"];
}

- (UIImage *)backgroundImage {
    return [UIImage imageNamed:@"comment-bg-ios7.png"];
}

- (void)hideSubscribedButton {
    self.subscribedButton.hidden = YES;
    
    CGRect frame = self.addCommentView.frame;
    frame.size.width = self.frame.size.width;
    frame.origin.x = self.frame.origin.x;
    frame = CGRectInset(frame, 8, 0);
    self.addCommentView.frame = frame;

}

- (void)dealloc {
    [searchBarImageView release];
    [addCommentButton release];
    [addCommentView_ release];
    [_subscribedButton release];
    [super dealloc];

}
@end
