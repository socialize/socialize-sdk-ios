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
    
    DemoEntity                  *_entity;
    Socialize                   *_service;
    
    id<SocializeLike>           _myLike;
}

-(id) initWithEntry: (DemoEntity*) entity andService: (Socialize*) service;

@end
