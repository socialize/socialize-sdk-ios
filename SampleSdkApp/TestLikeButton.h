//
//  TestLikeButton.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>

@interface TestLikeButton : UIViewController
- (id)initWithEntity:(id<SocializeEntity>)entity;

@property (nonatomic, retain) id<SocializeEntity> entity;
@end
