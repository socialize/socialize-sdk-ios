//
//  SocializeView.h
//  SocializeSDK
//
//  Created by Fawad Haider on 6/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeEntity.h"
#import "SocializeActivity.h"
#import "SocializeApplication.h"
#import "SocializeUser.h"


/**
 In progress
 */
@protocol SocializeView <SocializeActivity>
@end


@interface SocializeView : SocializeActivity<SocializeView> {
}

@end
