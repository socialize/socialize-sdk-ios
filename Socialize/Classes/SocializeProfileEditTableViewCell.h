//
//  ProfileEditTableViewCell.h
//  appbuildr
//
//  Created by William Johnson on 1/11/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger SocializeProfileEditTableViewCellHeight;

@interface SocializeProfileEditTableViewCell : UITableViewCell 

@property (nonatomic, retain) IBOutlet UILabel * keyLabel;
@property (nonatomic, retain) IBOutlet UILabel * valueLabel;
@property (nonatomic, retain) IBOutlet UIImageView * arrowImageView;
@end
