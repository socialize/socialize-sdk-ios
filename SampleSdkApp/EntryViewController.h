//
//  EntryViewController.h
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeActionView.h"
#import "DemoEntry.h"

@interface EntryViewController : UIViewController<UIWebViewDelegate, SocializeActionViewDelegate> {
    
@private
    SocializeActionView* _socializeActionPanel;
    UIWebView* _webView;
    
    DemoEntry* _entry;
}

-(id) initWithEntry: (DemoEntry*) entry;

@end
