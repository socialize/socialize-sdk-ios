//
//  SocializeProfileEditTableViewImageCell.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeProfileEditTableViewImageCell.h"

NSInteger SocializeProfileEditTableViewImageCellHeight = 65;

@implementation SocializeProfileEditTableViewImageCell
@synthesize imageView = imageView_;
@synthesize spinner = spinner_;
@synthesize valueLabel = valueLabel_;

- (void)dealloc {
    self.imageView = nil;
    self.spinner = nil;
    self.valueLabel = nil;
    
    [super dealloc];
}
@end
