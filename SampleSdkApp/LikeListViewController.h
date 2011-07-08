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


@interface LikeListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SocializeServiceDelegate> {

    UITableView     *_tableView;
    Socialize       *_service;
    NSMutableArray  *_likes;
    NSString        *_entityKey;
}

@property (retain,nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, assign) Socialize* service;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andService: (Socialize*) service andEntityKey:(NSString*)entityKey;

@end
