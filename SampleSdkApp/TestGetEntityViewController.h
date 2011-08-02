//
//  EntityViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Socialize.h"
#import "LoadingView.h"


@interface TestGetEntityViewController : UIViewController<SocializeServiceDelegate> {
    
    /*get entity*/
    
    IBOutlet UITextField* getEntityTextField;
    Socialize*            _socialize;
    LoadingView*          _loadingView;
    
    /*info view */
    
    IBOutlet UIView*      resultsView;
    IBOutlet UILabel*     keyLabel;
    IBOutlet UILabel*     nameLabel;
    IBOutlet UILabel*     commentsLabel;
    IBOutlet UILabel*     likesLabel;
    IBOutlet UILabel*     sharesLabel;
    
    IBOutlet UITextField* resultTextField;
    UIButton*    hiddenButton;
}

@property (retain, nonatomic) UILabel*   getEntityResultLabel;
-(IBAction)getEntity;
//-(IBAction)createEntity;

@end
