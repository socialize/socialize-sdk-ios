//
//  UIImage+ResizeTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/16/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "UIImage+ResizeTests.h"
#import "UIImage+Resize.h"

@implementation UIImage_ResizeTests

- (void)testResizingImage {
    UIImage *smiley = [UIImage imageNamed:@"Smiley.png"];
    
    UIImage *resized = [smiley imageWithSameAspectRatioAndWidth:300];
    GHAssertEquals((int)resized.size.width, 300, @"Bad width");
    GHAssertEquals((int)resized.size.height, 300, @"Bad height");
}

@end
