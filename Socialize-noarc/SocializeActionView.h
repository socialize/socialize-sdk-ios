//
//  SocializeActionView.h
//  appbuildr
//
//  Created by Fawad Haider  on 12/9/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SOCIALIZE_ACTION_PANE_HEIGHT 44

@class SocializeActionView;

@protocol SocializeActionViewDelegate <NSObject>

-(void)commentButtonTouched:(id)sender;
-(void)viewButtonTouched:(id)sender;
-(void)likeButtonTouched:(id)sender;
-(void)shareButtonTouched: (id) sender;
-(void)socializeActionViewWillAppear:(SocializeActionView*)socializeActionView;
-(void)socializeActionViewWillDisappear:(SocializeActionView*)socializeActionView;

@end


@interface SocializeActionView : UIView {
    
@private
	UIButton*	_commentButton;
	UIButton*	_likeButton;
	UIButton*	_viewCounter;
  	UIButton*	_shareButton;
	BOOL		_isLiked;
	
	UIFont*		_buttonLabelFont;

	UIActivityIndicatorView*          _activityIndicator;
	id<SocializeActionViewDelegate>   _socializeDelegate;
}

-(void)commentButtonPressed:(id)sender;
-(void)likeButtonPressed:(id)sender;

/*declared primarily for unit test purposes but can be used by the client*/
- (id)initWithFrame:(CGRect)frame labelButtonFont:(UIFont*)labelFont likeButton:(UIButton*)likeButton viewButton:(UIButton*)viewButton commentButton:(UIButton*)commentButton activityIndicator:(UIActivityIndicatorView*)activityIndicator;
- (id)initWithFrame:(CGRect)frame;
- (void)updateCountsWithViewsCount:(NSNumber*) viewsCount withLikesCount: (NSNumber*) likesCount isLiked: (BOOL)liked withCommentsCount: (NSNumber*) commentsCount;
- (void)updateViewsCount:(NSNumber*) viewsCount;
- (void)updateLikesCount:(NSNumber*) likesCount liked: (BOOL)isLiked;
- (void)updateCommentsCount: (NSNumber*) commentsCount;
- (void)updateIsLiked: (BOOL)isLiked;
- (void)lockButtons;
- (void)unlockButtons;
- (void)startActivityForUpdateViewsCount;
- (void)positionInSuperview;
- (void)hideButtons;
- (void)showButtons;

@property (nonatomic, assign) id<SocializeActionViewDelegate> delegate;
@property (nonatomic, readonly) BOOL isLiked;
@property (nonatomic, assign) BOOL noAutoLayout;


@end