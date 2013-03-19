//
//  main.m
//  UnitTests
//
//  Created by Nathaniel Griswold on 6/18/12.
//  Copyright (c) 2012 Nathaniel Griswold. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SocializeUnitTestApplication.h"
#import "SocializeDeviceTokenSender.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [SocializeDeviceTokenSender disableSender];

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([SocializeUnitTestApplication class]));
    }
}
