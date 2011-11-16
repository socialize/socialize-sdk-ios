//
//  AuthenticateViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/10/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>
#import "SocializeLoadingView.h"

@interface AuthenticateViewController : UIViewController<SocializeServiceDelegate> {
    
    Socialize*              socialize;
    UILabel*                _resultLabel;
    SocializeLoadingView*            _loadingView;
    
    IBOutlet UITextField*   _keyField;
    IBOutlet UITextField*   _secretField;

    IBOutlet UIButton*      _authenticateButton;
    IBOutlet UIButton*      _thirdpartyAuthentication;
    IBOutlet UIButton*      _emptyCacheButton;
}

@property (retain,nonatomic) IBOutlet UITextField*   keyField;
@property (retain,nonatomic) IBOutlet UITextField*   secretField;
@property (retain,nonatomic) IBOutlet UILabel*       resultLabel;
@property (nonatomic, readonly) Socialize*           socialize;

-(IBAction)authenticate:(id)sender;
-(IBAction)authenticateViaFacebook:(id)sender;
-(IBAction)textFieldReturn:(id)sender;
-(IBAction)backgroundTouched:(id)sender;
-(IBAction)emptyCache:(id)sender;

@end
