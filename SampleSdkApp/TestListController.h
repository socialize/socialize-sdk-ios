//
//  TestListController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SocializeUser;

@interface TestListController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    
    NSArray*                _testList;
    IBOutlet UITableView*   _tableView;
    SocializeUser*          _user;
}

@property(nonatomic, retain) SocializeUser* user;

@end
