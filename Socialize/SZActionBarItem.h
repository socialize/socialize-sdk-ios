//
//  SZActionBarItem.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SocializeObjects.h"

@class SZActionBar;

@protocol SZActionBarItem <NSObject>
- (void)actionBarDidAddAsItem:(SZActionBar*)actionBar;
- (void)actionBar:(SZActionBar*)actionBar didLoadEntity:(id<SZEntity>)entity;

@end
