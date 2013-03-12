//
//  main.m
//  IntegrationTests
//
//  Created by Nathaniel Griswold on 6/18/12.
//  Copyright (c) 2012 Nathaniel Griswold. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IntegrationTestsAppDelegate.h"
#import "SZUnitTestAppHack.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [SZUnitTestAppHack setDelegateClassName:NSStringFromClass([IntegrationTestsAppDelegate class])];
        return UIApplicationMain(argc, argv, NSStringFromClass([SZUnitTestAppHack class]), NSStringFromClass([IntegrationTestsAppDelegate class]));
    }
}
