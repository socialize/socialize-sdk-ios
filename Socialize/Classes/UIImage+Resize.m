//
//  UIImage+Resize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/16/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage*)imageWithSameAspectRatioAndWidth:(CGFloat)newWidth {
    CGFloat newHeight = self.size.height / self.size.width * newWidth;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
