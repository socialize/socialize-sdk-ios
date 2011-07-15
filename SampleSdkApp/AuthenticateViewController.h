//
//  AuthenticateViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/10/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Socialize.h"
#import "LikeViewController.h"

@interface AuthenticateViewController : UIViewController<SocializeAuthenticationDelegate> {
    
    Socialize*              socialize;
    IBOutlet UITextField*   _keyField;
    IBOutlet UITextField*   _secretField;
    
    LikeViewController*     likeViewController;
}

@property (retain,nonatomic) IBOutlet UITextField*   keyField;
@property (retain,nonatomic) IBOutlet UITextField*   secretField;
@property (retain, nonatomic) LikeViewController* likeViewController;

-(IBAction)authenticate:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
