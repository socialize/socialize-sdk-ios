//
//  CommentsTableViewCell.h
//  appbuildr
//
//  Created by Fawad Haider  on 11/30/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell{

	IBOutlet UILabel	 *headlineLabel;
	IBOutlet UILabel	 *summaryLabel;
	IBOutlet UILabel     *dateLabel;
	IBOutlet UIImageView *userProfileImage;
	IBOutlet UIImageView *bgImage;

    UIImageView          *locationPin;
	NSString			 *mycomment;
	NSInteger			 cellHeight;
    UIButton             *btnViewProfile;

}

@property (retain, nonatomic) IBOutlet UILabel	*headlineLabel;
@property (retain, nonatomic) IBOutlet UILabel	*summaryLabel;
@property (retain, nonatomic) IBOutlet UILabel	*dateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *userProfileImage; 
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;
@property (retain, nonatomic) IBOutlet UIImageView *locationPin;
@property (nonatomic, retain) IBOutlet UIButton * btnViewProfile;

- (void)setComment:(NSString*)mytext;
- (UIImage *)defaultBackgroundImage;
- (UIImage *)defaultProfileImage;
+ (CGFloat)getCellHeightForString:(NSString*)forThisString;
+ (NSString *)nibName;
@end
