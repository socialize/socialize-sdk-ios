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
-(void)likeListButtonTouched:(id)sender;
//-(void)shareButtonTouched:(id)sender;

@end


@interface SocializeActionView : UIView {
    
@private
	UIButton*	_commentButton;
	UIButton*	_likeButton;
	UIButton*	_viewCounter;
	UIButton*	_likeListButton;
	
    
	UIFont*		_buttonLabelFont;
    
	UIActivityIndicatorView*  _activityIndicator;
	
	BOOL		_isLiked;

	id<SocializeActionViewDelegate>   _socializeDelegate;
}

- (id)initWithFrame:(CGRect)frame;
- (void) updateCountsWithViewsCount:(NSNumber*) viewsCount withLikesCount: (NSNumber*) likesCount isLiked: (BOOL)liked withCommentsCount: (NSNumber*) commentsCount;
- (void) updateViewsCount:(NSNumber*) viewsCount;
- (void) updateLikesCount:(NSNumber*) likesCount liked: (BOOL)isLiked;
- (void) updateCommentsCount: (NSNumber*) commentsCount;
- (void) updateIsLiked: (BOOL)isLiked;

@property (nonatomic, assign) id<SocializeActionViewDelegate> delegate;
@property (nonatomic, readonly) BOOL isLiked;

@end