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

- (void)dealloc {

   [searchBarImageView release];
   [addCommentButton release];
   [super dealloc];

}
@end
