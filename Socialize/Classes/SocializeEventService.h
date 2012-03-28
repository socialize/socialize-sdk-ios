//
//  SocializeEventService.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/28/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeService.h"

@interface SocializeEventService : SocializeService
- (void)trackEventWithBucket:(NSString*)bucket values:(NSDictionary*)values;

@end
