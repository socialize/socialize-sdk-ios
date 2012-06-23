//
//  SZActionBarItem.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/23/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SZActionBarItem <NSObject>

- (void)setEntity:(id<SZEntity>)entity;

@end
