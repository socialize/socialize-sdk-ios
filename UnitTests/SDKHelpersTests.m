//
//  SDKHelpersTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 7/16/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SDKHelpersTests.h"
#import "SDKHelpers.h"
#import "socialize_globals.h"

@implementation SDKHelpersTests

- (void)copyFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:toPath] == YES) {
        [fileManager removeItemAtPath:toPath error:&error];
        NSAssert(error == nil, @"Error removing file: %@", [error localizedDescription]);
    }
    
    [fileManager copyItemAtPath:fromPath toPath:toPath error:&error];
    
    NSAssert(error == nil, @"Error copying file: %@", [error localizedDescription]);
}

- (NSString*)embeddedPath {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"embedded.mobileprovision"];
}

//- (void)testExampleDevProvisioningIsNotProduction {
//    NSString *mobileprovision = [[NSBundle mainBundle] pathForResource:@"example-dev.embedded.mobileprovision" ofType:nil];
//    [self copyFileFromPath:mobileprovision toPath:[self embeddedPath]];
//    
//    BOOL isProduction = SZIsProduction();
//    GHAssertFalse(isProduction, @"Should not be prod");
//}
//
//- (void)testExampleDistributionProvisioningIsProduction {
//    NSString *mobileprovision = [[NSBundle mainBundle] pathForResource:@"example-distribution.embedded.mobileprovision" ofType:nil];
//    [self copyFileFromPath:mobileprovision toPath:[self embeddedPath]];
//    
//    BOOL isProduction = SZIsProduction();
//    GHAssertTrue(isProduction, @"Should be prod");
//}
//
//- (void)testNilProvisioningIsNotProduction {
//    NSError *error = nil;
//    [[NSFileManager defaultManager] removeItemAtPath:[self embeddedPath] error:&error];
//
//    BOOL isProduction = SZIsProduction();
//    GHAssertFalse(isProduction, @"Should not be prod");
//}

@end
