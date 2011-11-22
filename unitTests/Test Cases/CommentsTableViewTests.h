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

@class SocializeCommentsTableViewController;
@class SocializeComposeMessageViewController;

@interface CommentsTableViewTests : GHTestCase {
    SocializeCommentsTableViewController* listView;
    id                                    postCommentController;
}

@property (nonatomic, retain) id mockSocialize;
@property (nonatomic, retain) id mockComment;
@property (nonatomic, retain) id partialMockCommentTableViewController;

@end
