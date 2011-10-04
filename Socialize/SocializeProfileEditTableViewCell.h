//
//  ProfileEditTableViewCell.h
//  appbuildr
//
//  Created by William Johnson on 1/11/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SocializeProfileEditTableViewCell : UITableViewCell 
{
	UILabel * keyLabel;
	UILabel * valueLabel;
	UIImageView * theImageView;
	UIActivityIndicatorView * spinner;
}
@property (nonatomic, retain) IBOutlet UILabel * keyLabel;
@property (nonatomic, retain) IBOutlet UILabel * valueLabel;
@property (nonatomic, retain) IBOutlet UIImageView * theImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * spinner;

@end
