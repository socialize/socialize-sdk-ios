//
//  SocializePinterestTests.m
//  Socialize
//
//  Created by David Jedeikin on 4/16/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SocializePinterestTests.h"
#import "SZPinterestEngine.h"

@implementation SocializePinterestTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testShareViaPinterestWithViewController {
    UIViewController *dummyController = (UIViewController *)[OCMockObject mockForClass:[UIViewController class]];
    id mockPinterestUtils = [OCMockObject mockForClass:[SZPinterestUtils class]];
    [[[mockPinterestUtils stub] andReturnValue:@YES] isAvailable];
    id<SZEntity> *entity = [SZEntity entityWithKey:@"http://www.sharethis.com" name:@"ShareThis"];
    /*
     STAPIClient *dummyAPIClient = (STAPIClient *)[OCMockObject mockForClass:[STAPIClient class]];

     */
}

@end
