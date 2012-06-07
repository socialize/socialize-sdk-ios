//
//  UITableView+Resize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/14/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "UITableView+Resize.h"

@implementation UITableView (Resize)

- (NSIndexPath*)lastIndexPath {
    NSInteger lastSection = [self numberOfSections] - 1;
    NSInteger lastRow = [self numberOfRowsInSection:lastSection] - 1;
    
    return [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
}

- (UITableViewCell*)firstCell {
    if ([self numberOfSections] == 0 || [self numberOfRowsInSection:0] == 0) {
        return nil;
    }
    
    return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (UITableViewCell*)lastCell {
    return [self cellForRowAtIndexPath:[self lastIndexPath]];
}

- (void)sizeToCells {
    CGRect origFrame = self.frame;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGFLOAT_MAX);
    
    UITableViewCell *firstCell = [self firstCell];
    UITableViewCell *lastCell = [self lastCell];
    CGRect lastCellFrame = [self convertRect:lastCell.frame fromView:lastCell.superview];
    CGRect firstCellFrame = [self convertRect:firstCell.frame fromView:firstCell.superview];
    CGRect frame = origFrame;
    
    CGFloat padToTopCell = firstCellFrame.origin.y;
    
    frame.size.height = lastCellFrame.origin.y + lastCellFrame.size.height - firstCellFrame.origin.y + 2*padToTopCell;
    
    self.frame = frame;
}


@end
