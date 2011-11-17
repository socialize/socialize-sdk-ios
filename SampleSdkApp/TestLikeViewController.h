//
//  TestLikeViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>
#import "SocializeLoadingView.h"


@interface TestLikeViewController : UIViewController<SocializeServiceDelegate> {

    /*get entity*/
    IBOutlet UIButton*    unlikeButton;
    IBOutlet UIButton*    likeButton;
    IBOutlet UITextField* entityTextField;

    BOOL                  _isLiked;
    Socialize*            _socialize;
    SocializeLoadingView*          _loadingView;
    NSMutableArray*       _likes;
    
    /*info view */
    
    IBOutlet UIView*      resultsView;
    IBOutlet UILabel*     keyLabel;
    IBOutlet UILabel*     nameLabel;
    IBOutlet UILabel*     commentsLabel;
    IBOutlet UILabel*     likesLabel;
    IBOutlet UILabel*     sharesLabel;
    
    IBOutlet UITextField* resultTextField;
    UIButton*             hiddenButton;

    
}
-(IBAction)toggleLike;
-(IBAction)toggleUnlike;
@end
