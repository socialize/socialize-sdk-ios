//
//  TestFetchCommentsViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Socialize.h"
#import "LoadingView.h"

@interface TestFetchCommentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SocializeServiceDelegate> {
    
    IBOutlet UITextField*     _textField;
    IBOutlet UITableView*     _tableView;
    IBOutlet UIButton*        _fetchButton;
    LoadingView*              _loadingView;
    
    NSArray*                  _comments;
    Socialize*                _socialize;
    
    IBOutlet UITextField*     resultTextField;
    UIButton*                 hiddenButton;

}

-(IBAction)getComments;   
@end
