//
//  TestCreateViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/27/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>
#import "SocializeLoadingView.h"


@interface TestCreateEntityViewController : UIViewController<SocializeServiceDelegate> {

    /*create entity*/
    IBOutlet UILabel*     createEntityResultLabel;
    IBOutlet UITextField* createEntityUrlTextField;
    IBOutlet UITextField* createEntityNameTextField;
    IBOutlet UIButton*    createButton;
    
    Socialize*            _socialize;
    SocializeLoadingView*          _loadingView;
    
    /*info view */
    IBOutlet UIView*      resultsView;
    IBOutlet UILabel*     successLabel;
    IBOutlet UILabel*     keyLabel;
    IBOutlet UILabel*     nameLabel;
    IBOutlet UILabel*     commentsLabel;
    IBOutlet UILabel*     likesLabel;
    IBOutlet UILabel*     sharesLabel;
    
    IBOutlet UITextField* resultTextField;
    UIButton*             hiddenButton;

}

@property (retain, nonatomic) UILabel*  createEntityResultLabel;
-(IBAction)backgroundTouched;
-(IBAction)createEntity;

@end
