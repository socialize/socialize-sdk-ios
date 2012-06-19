//
//  UITableView+Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/15/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UITableView+Socialize.h"

@implementation UITableView (Socialize)

- (NSInteger)offsetForIndexPath:(NSIndexPath*)indexPath {
    NSInteger offset = 0;
    for (int i = 0; i < indexPath.section; i++) {
        offset += [self numberOfRowsInSection:i];
    }
    offset += indexPath.row;
    return offset;
}


@end
