//
//  CommentsTableViewTests.h
//  SocializeSDK
//
//  Created by Fawad Haider on 9/13/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <UIKit/UIKit.h>
#import "SocializeTableViewTests.h"

@class SocializeCommentsTableViewController;
@class SocializeComposeMessageViewController;

@interface CommentsTableViewTests : SocializeTableViewTests

@property (nonatomic, retain) SocializeCommentsTableViewController *commentsTableViewController;
@property (nonatomic, retain) id mockSubscribedButton;
@property (nonatomic, retain) id mockBubbleView;
@property (nonatomic, retain) id mockBubbleContentView;
@property (nonatomic, retain) id mockFooterView;


@end
