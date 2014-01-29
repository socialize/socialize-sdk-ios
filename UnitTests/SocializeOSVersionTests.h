//
//  SocializeOSVersionTests.h
//  Socialize
//
//  Created by David Jedeikin on 1/15/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>

@interface SocializeOSVersionTests : GHTestCase

- (void)assertMatchClass:(NSObject *)obj ios6ClassName:(NSString *)ios6Name ios7ClassName:(NSString *)ios7Name;
@end
