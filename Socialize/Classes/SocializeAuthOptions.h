//
//  SocializeAuthOptions.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/26/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeOptions.h"

@interface SocializeAuthOptions : SocializeOptions
@property (nonatomic, assign) BOOL doNotPromptForPermission;

@end
