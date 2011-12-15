//
//  SocializeSubscriptionService.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/14/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeService.h"

@interface SocializeSubscriptionService : SocializeService

- (void)subscribeToCommentsForEntityKey:(NSString*)entityKey;
- (void)unsubscribeFromCommentsForEntityKey:(NSString*)entityKey;
- (void)getSubscriptionsForEntityKey:(NSString*)entityKey first:(NSNumber*)first last:(NSNumber*)last;

@end
