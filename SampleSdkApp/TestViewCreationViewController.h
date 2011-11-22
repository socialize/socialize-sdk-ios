//
//  TestViewCreationViewController.h
//  SocializeSDK
//
//  Created by Sergey Popenko on 8/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>
#import "SocializeLoadingView.h"

@interface TestViewCreationViewController : UIViewController<SocializeServiceDelegate> {
 
    /*get entity*/
    
    IBOutlet UITextField* entityTextField;
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
    IBOutlet UILabel*     viewsLabel;
    
    IBOutlet UITextField*  resultTextField;
    UIButton*              hiddenButton;

}

-(IBAction)createView;
@end
