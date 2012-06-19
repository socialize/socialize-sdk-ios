//
//  SocializeVerticalLayoutContainerView.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocializeVerticalLayoutContainerView : UIView

@property (nonatomic, retain) NSArray *rows;

- (void)layoutRows;

@end
