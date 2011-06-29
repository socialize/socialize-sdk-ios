//
//  EntryViewController.h
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeActionView.h"
#import "CommentsViewController.h"
#import "DemoEntry.h"

#import "Socialize.h"
#import "SocializeCommonDefinitions.h"

@interface EntityViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate, SocializeEntityServiceDelegate, SocializeActionViewDelegate, SocializeLikeServiceDelegate> {
    
@private
    SocializeActionView         *_socializeActionPanel;
    UINavigationController      *_commentsNavigationController;
    UIWebView                   *_webView;
    
    DemoEntry                   *_entry;
    Socialize                   *_service;
    
    IBOutlet UITextField        *keyField;
    IBOutlet UITextField        *nameField;
    IBOutlet UITextView         *resultsView;
    IBOutlet UIButton           *createButton;
    id<SocializeEntity>         _entity;
    id<SocializeLike>           _myLike;
}

-(id) initWithEntry: (DemoEntry*) entry andService: (Socialize*) service;
-(IBAction)createNew:(id)button;

@end
