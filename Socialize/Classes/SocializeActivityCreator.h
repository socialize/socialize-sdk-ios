//
//  SocializeActivityCreator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeAction.h"
#import "SocializeActivityOptions.h"
#import "SocializeFacebookWallPostOptions.h"
#import "SocializeActivity.h"

@interface SocializeActivityCreator : SocializeAction
@property (nonatomic, retain) NSSet *thirdParties;
@property (nonatomic, retain) SocializeActivityOptions *options;
@property (nonatomic, retain) id<SocializeActivity> activity;

- (id)initWithActivity:(id<SocializeActivity>)activity
               options:(SocializeOptions*)options
          displayProxy:(SocializeUIDisplayProxy*)displayProxy
               display:(id<SocializeUIDisplay>)display;

- (void)createActivityOnSocializeServer;
- (NSString*)defaultText;
- (void)succeedServerCreateWithActivity:(id<SocializeActivity>)activity;
- (NSString*)textForFacebook;
- (NSString*)textForTwitter;

@end
