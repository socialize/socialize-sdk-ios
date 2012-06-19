//
//  UITableView+Resize.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Resize)

- (NSIndexPath*)lastIndexPath;
- (UITableViewCell*)firstCell;
- (UITableViewCell*)lastCell;
- (void)sizeToCells;

@end
