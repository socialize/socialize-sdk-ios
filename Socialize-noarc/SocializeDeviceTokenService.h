//
//  SocializeNotificationService.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/7/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeService.h"

@interface SocializeDeviceTokenService : SocializeService
- (void)registerDeviceTokenString:(NSString *)deviceToken development:(BOOL)development;
@end
