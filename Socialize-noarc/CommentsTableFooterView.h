//
//  CommentsTableHeaderView.h
//  appbuildr
//
//  Created by Fawad Haider  on 1/13/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableFooterView : UIView
{
    UIImageView     *searchBarImageView;
    UIButton        *addCommentButton;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *searchBarImageView;
@property (nonatomic, retain) IBOutlet UIButton *addCommentButton;
@property (nonatomic, retain) IBOutlet UIView *addCommentView;
@property (retain, nonatomic) IBOutlet UIButton	*subscribedButton;

- (void)hideSubscribedButton;
- (UIImage *)searchBarImage;
- (UIImage *)backgroundImage;

@end
