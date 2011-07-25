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
///#import "DemoEntity.h"

#import "Socialize.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeLike.h"

@interface EntityViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate, SocializeActionViewDelegate, SocializeServiceDelegate> {
    
@private
    SocializeActionView         *_socializeActionPanel;
    UINavigationController      *_commentsNavigationController;
    UIWebView                   *_webView;
    
    Socialize                   *_service;
    id<SocializeLike>           _myLike;
    id <SocializeView>          _myView;
}

@property (retain, nonatomic)  id<SocializeEntity> entity;

-(id) initWithEntry: (id<SocializeEntity>) entity andService:(Socialize*)service;

@end
