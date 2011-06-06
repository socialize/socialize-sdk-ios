//
//  SocializeActionView.h
//  appbuildr
//
//  Created by Fawad Haider  on 12/9/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SocializeActionViewDelegate <NSObject>

-(void)commentButtonTouched:(id)sender;
-(void)likeButtonTouched:(id)sender;
-(void)shareButtonTouched:(id)sender;

@end


@interface SocializeActionView : UIView {
    
@private
	UIButton*	_commentButton;
	UIButton*	_likeButton;
	UIButton*	_shareButton;
	UIButton*	_viewCounter;
	
	UIFont*		_buttonLabelFont;
    
	UIActivityIndicatorView*  _activityIndicator;
	
	BOOL		_isLiked;

	id<SocializeActionViewDelegate>   _socializeDelegate;
}

- (id)initWithFrame:(CGRect)frame;
- (void) updateCountsWithViewsCount:(NSNumber*) viewsCount withLikesCount: (NSNumber*) likesCount withCommentsCount: (NSNumber*) commentsCount;

@property (nonatomic, assign) id<SocializeActionViewDelegate> delegate;
@property (nonatomic, assign) BOOL isLiked;

@end