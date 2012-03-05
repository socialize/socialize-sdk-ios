//
//  SocializeFacebookWallPosterOptions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeFacebookAuthOptions.h"
#import "SocializeOptions.h"

@interface SocializeFacebookWallPostOptions : SocializeOptions
@property (nonatomic, retain) SocializeFacebookAuthOptions *facebookAuthOptions;

// These map to the actual Facebook feed parameters
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *name;

@end
