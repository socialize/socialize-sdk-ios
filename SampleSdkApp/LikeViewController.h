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
    
    UITextField*        _entityEntryField;
    UIButton*           _likeBtn;
    Socialize*          _socialize;
    id<SocializeLike>   _like;
}

@property (retain, nonatomic) IBOutlet UITextField* entityEntryField;
@property (retain, nonatomic) IBOutlet UIButton* likeBtn;
@property (retain, nonatomic) Socialize* socialize;

-(IBAction)buttonTouched:(id)sender;

@end
