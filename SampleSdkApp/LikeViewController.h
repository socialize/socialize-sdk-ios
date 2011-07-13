//
//  LikeViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Socialize.h"
#import "SocializeLike.h"

@interface LikeViewController : UIViewController<SocializeServiceDelegate> {
    
    UITextField*        txtField;
    UIButton*           button;
    Socialize*          _socialize;
    id<SocializeLike>   _like;
}

@property (retain, nonatomic) IBOutlet UITextField* txtField;
@property (retain, nonatomic) IBOutlet UIButton* button;
@property (retain, nonatomic) Socialize* socialize;

-(IBAction)buttonTouched:(id)sender;

@end
