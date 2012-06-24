//
//  SZActionButton.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZActionBarItem.h"

@interface SZActionButton : UIView <SZActionBarItem>

@property (nonatomic, strong) UIButton *actualButton;
@property (nonatomic, strong) UIImage *disabledImage;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) BOOL autoresizeDisabled;

- (void)autoresize;

@end
