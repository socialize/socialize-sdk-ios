//
//  UIImage+Resize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/16/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
- (UIImage*)imageWithSameAspectRatioAndWidth:(CGFloat)newWidth;
@end
