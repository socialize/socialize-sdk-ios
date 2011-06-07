//
//  CommentsViewController.h
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/6/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommentsViewController : UIViewController<UITableViewDataSource> {

@private
    UITextField* _commentText;
    UIButton* _sendButton;
    UITableView* _commentsTable;
}

@property (nonatomic, retain) IBOutlet UITextField* commentText;
@property (nonatomic, retain) IBOutlet UIButton* sendButton;
@property (nonatomic, retain) IBOutlet UITableView* commentsTable;

-(IBAction) sendBtnPressed: (id) sender;

@end
