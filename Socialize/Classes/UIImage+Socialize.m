//
//  UIImage+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/22/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "UIImage+Socialize.h"
#import "_Socialize.h"

@implementation UIImage (Socialize)

+ (UIImage*)socializeImageNamed:(NSString*)imageName {
    NSString *resourcePath = [Socialize relativeResourcePath:imageName];
    return [UIImage imageNamed:resourcePath];
}

@end
