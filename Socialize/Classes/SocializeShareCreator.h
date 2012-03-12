//
//  SocializeShareCreator.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeActivityCreator.h"
#import "SocializeShare.h"
#import "SocializeShareOptions.h"

@interface SocializeShareCreator : SocializeActivityCreator

+ (void)createShare:(id<SocializeShare>)share
            options:(SocializeShareOptions*)options
            display:(id)display
            success:(void(^)(id<SocializeShare>))success
            failure:(void(^)(NSError *error))failure;

@property (nonatomic, readonly) id<SocializeShare> share;
@end
