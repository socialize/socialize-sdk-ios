//
//  SocializeHorizontalContainer.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZHorizontalContainerView : UIView

@property (nonatomic, retain) NSArray *columns;
@property (nonatomic, assign) BOOL centerColumns;
@property (nonatomic, assign, getter=isRightJustied) BOOL rightJustified;
@property (nonatomic, assign) CGFloat initialPadding;
@property (nonatomic, assign) CGFloat padding;

- (void)layoutColumns;

@end