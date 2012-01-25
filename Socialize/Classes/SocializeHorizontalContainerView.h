//
//  SocializeHorizontalContainer.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/20/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocializeHorizontalContainerView : UIView

@property (nonatomic, retain) NSArray *columns;

- (void)layoutColumns;

@end