//
//  CommentsViewController.h
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/6/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Socialize.h"

@interface CommentsViewController : UIViewController<UITableViewDataSource, SocializeServiceDelegate> {

@private
    UITextField*    _commentText;
    UIButton*       _sendButton;
    UITableView*    _commentsTable;
    
    Socialize*      _service;
    NSString*       _entityKey;
    NSMutableArray* _comments;
}

@property (nonatomic, retain) IBOutlet UITextField* commentText;
@property (nonatomic, retain) IBOutlet UIButton*    sendButton;
@property (nonatomic, retain) IBOutlet UITableView* commentsTable;
@property (nonatomic, assign) Socialize*            service;
@property (nonatomic, copy) NSString*               entityKey;

-(IBAction) sendBtnPressed: (id) sender;

@end
