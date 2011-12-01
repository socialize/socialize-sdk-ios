//
//  SocializeProfileEditTableViewImageCell.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger SocializeProfileEditTableViewImageCellHeight;

@interface SocializeProfileEditTableViewImageCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;

@end
