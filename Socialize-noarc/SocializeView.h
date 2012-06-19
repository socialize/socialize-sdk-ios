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
 Protocol for socialize view representation.
 */
@protocol SocializeView <SocializeActivity>
@end

/**Private implementation of <SocializeView> protocol*/
@interface SocializeView : SocializeActivity<SocializeView> {
}

+ (SocializeView*)viewWithEntity:(id<SocializeEntity>)entity;


@end
