//
//  SocializeTestCase.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@interface SocializeTestCase : GHAsyncTestCase
@property (nonatomic, retain) UIAlertView *lastShownAlert;
@property (nonatomic, retain) NSMutableDictionary *expectedDeallocations;
- (void)expectDeallocationOfObject:(NSObject*)object fromTest:(SEL)test;
@end
