//
//  SocializeTestCase.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/20/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
@interface SocializeAsyncTestCase : GHAsyncTestCase {
    
}
- (void)waitForStatus:(NSInteger)status;
@end
