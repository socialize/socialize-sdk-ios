//
//  MyClass.m
//  SocializeSDK
//
//  Created by William Johnson on 5/9/11.
//  Copyright 2011 PointAbout, Inc. All rights reserved.
//

#import "MyClass.h"
#import "UnitTestConfigurationCheck.h"

@implementation MyClass

- (void) testFirstUT 
{
    UnitTestConfigurationCheck * test = [[[UnitTestConfigurationCheck alloc]init]autorelease];
    
    int number = [test intForfailedCase];
    NSLog(@"NUBMER ------->%i", number);
    GHAssertEquals(number, 2, @"Should fail");
}

- (void) testSecondUT 
{
    GHAssertEquals(1, 1, @"Should pass");
}


@end
