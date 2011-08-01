//
//  TestLikeViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Socialize.h"
#import "LoadingView.h"


@interface TestLikeViewController : UIViewController<SocializeServiceDelegate> {

    /*get entity*/
    
    IBOutlet UITextField* entityTextField;
    BOOL                  _isLiked;
    Socialize*            _socialize;
    LoadingView*          _loadingView;
    NSMutableArray*       _likes;
    
    /*info view */
    
    IBOutlet UIView*      resultsView;
    IBOutlet UILabel*     successLabel;
    IBOutlet UILabel*     keyLabel;
    IBOutlet UILabel*     nameLabel;
    IBOutlet UILabel*     commentsLabel;
    IBOutlet UILabel*     likesLabel;
    IBOutlet UILabel*     sharesLabel;
    
}
-(IBAction)toggleLike;
-(IBAction)toggleUnlike;
@end
