//
//  CommentsTableFooterView.m
//  appbuildr
//
//  Created by Fawad Haider  on 1/13/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CommentsTableFooterView.h"



@implementation CommentsTableFooterView

@synthesize searchBarImageView;
@synthesize addCommentButton;
@synthesize addCommentView = addCommentView_;
@synthesize subscribedButton = _subscribedButton;

//- (void)adjustTableHeaderHeight:(NSInteger)diff{
//
//    self.frame = CGRectMake(self.frame.origin.x, 
//							self.frame.origin.y + diff, 
//							self.frame.size.width, 
//							self.frame.size.height - diff);
//	
//	[delegate adjustAdjacentViewHeight:diff];
//}


-(void)layoutSubviews{
    
    UIImage *sbImg = [[UIImage imageNamed:@"socialize-comment-background-text-input.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    self.searchBarImageView.image = sbImg;
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
