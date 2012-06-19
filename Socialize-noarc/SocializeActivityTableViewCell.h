//
//  ActivityTableViewCell.h
//  appbuildr
//
//  Created by Isaac Mosquera on 11/23/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SocializeActivityTableViewCellReuseIdentifier;
extern const CGFloat SocializeActivityTableViewCellHeight;

@interface SocializeActivityTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *activityTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentTextLabel;
@property (nonatomic, retain) IBOutlet UIImageView * profileImageView;
@property (nonatomic, retain) IBOutlet UIImageView * activityIcon;
@property (nonatomic, retain) IBOutlet UIView * informationView;
@property (nonatomic, retain) IBOutlet UIView * profileView;
@property (nonatomic, retain) IBOutlet UIButton * btnViewProfile;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * profileImageActivity;
@property (nonatomic, retain) IBOutlet UIImageView * disclosureImage;
@end
