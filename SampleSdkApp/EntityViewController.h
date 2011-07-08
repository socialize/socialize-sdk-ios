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
#import "DemoEntity.h"

#import "Socialize.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeLike.h"

@interface EntityViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate, SocializeActionViewDelegate, SocializeServiceDelegate> {
    
@private
    SocializeActionView         *_socializeActionPanel;
    UINavigationController      *_commentsNavigationController;
    UIWebView                   *_webView;
    
    DemoEntity                  *_entry;
    Socialize                   *_service;
    
    IBOutlet UITextField        *keyField;
    IBOutlet UITextField        *nameField;
    IBOutlet UITextView         *resultsView;
    IBOutlet UIButton           *createButton;
    id<SocializeLike>           _myLike;
    id<SocializeEntity>         _anotherEntity;

}

-(id) initWithEntry: (DemoEntity*) entry andService: (Socialize*) service;
-(IBAction)createNew:(id)button;

@end
