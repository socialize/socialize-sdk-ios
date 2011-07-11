//
//  AuthenticateViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/10/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityListViewController.h"

@interface AuthenticateViewController : UIViewController<SocializeAuthenticationDelegate> {
    
    Socialize*           socialize;
    IBOutlet UITextField*   _keyField;
    IBOutlet UITextField*   _secretField;
    
    EntityListViewController* entityListViewController;
}

@property (retain,nonatomic) IBOutlet UITextField*   keyField;
@property (retain,nonatomic) IBOutlet UITextField*   secretField;


-(IBAction)authenticate:(id)sender;


@end
