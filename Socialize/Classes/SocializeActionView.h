//
//  SocializeActionLayoutView.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeActionBarView.h"
#import "SocializeActionRecommendationsView.h"

@class SocializeActionView;

@protocol SocializeActionViewDelegate <NSObject>
-(void)socializeActionViewWillAppear:(SocializeActionView*)socializeActionView;
-(void)socializeActionViewWillDisappear:(SocializeActionView*)socializeActionView;
@end



@interface SocializeActionView : UIView
@property (nonatomic, assign) id<SocializeActionViewDelegate, SocializeActionBarViewDelegate, UITableViewDelegate, UITableViewDataSource> delegate;
@property (nonatomic, retain) SocializeActionRecommendationsView *recommendationsView;
@property (nonatomic, retain) SocializeActionBarView *barView;
@end
