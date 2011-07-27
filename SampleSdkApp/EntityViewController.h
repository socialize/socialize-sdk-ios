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


@interface EntityViewController : UIViewController<SocializeServiceDelegate> {
    
    IBOutlet UITextField* getEntityTextField;
    IBOutlet UITextField* createEntityTextField;
    Socialize*            _socialize;
    LoadingView*          _loadingView;

}

-(IBAction)getEntity;
//-(IBAction)createEntity;


@end
