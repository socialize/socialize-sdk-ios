//
//  LikeListViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeCommonDefinitions.h"
#import "Socialize.h"
#import "LoadingView.h"

@interface LikeListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SocializeServiceDelegate> {

    UITableView         *_tableView;
    Socialize           *_socialize;
    NSArray             *_likes;
    NSString            *_entityKey;

    IBOutlet UITextField* resultTextField;
    IBOutlet UITextField* entityField;
    UIButton*             hiddenButton;

    LoadingView*          _loadingView;
}

@property (retain,nonatomic) IBOutlet UITableView* tableView;
-(IBAction)getLikes;
@end
