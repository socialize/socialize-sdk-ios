//
//  SocializeActionView.h
//  appbuildr
//
//  Created by Fawad Haider  on 12/9/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SocializeActionViewDelegate <NSObject>

//-(void)commentButtonTouched:(Entry*)entry;
//-(void)likeButtonTouched:(Entry*)entry;
//-(void)shareButtonTouched:(Entry*)entry;

@end


@interface SocializeActionView : UIView {
    
@private
	UIButton*	_commentButton;
	UIButton*	_likeButton;
	UIButton*	_shareButton;
	UIButton*	_viewCounter;
	
	UIFont*		_buttonLabelFont;
	UIColor*	_shadowColor;
    
    UIImageView* _newCommentMarker;
	UIActivityIndicatorView*  _activityIndicator;
	
	BOOL		_drawBackViewShadows;
	BOOL		_observersAdded;
	BOOL		_hasNewComment;
	
//	Entry					 *entry;
	id<SocializeActionViewDelegate>   _socializeDelegate;
}

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) id<SocializeActionViewDelegate> delegate;

@end