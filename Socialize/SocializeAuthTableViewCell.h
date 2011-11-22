//
//  AuthorizeTableViewCell.h
//  appbuildr
//
//  Created by Fawad Haider  on 5/19/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SocializeAuthTableViewCell : UITableViewCell {
    UIImageView* cellIcon;
    UILabel*     cellLabel;
    UIImageView* cellAccessoryIcon;
}

@property (retain, nonatomic) IBOutlet UIImageView* cellIcon;  
@property (retain, nonatomic) IBOutlet UIImageView* cellAccessoryIcon;  
@property (retain, nonatomic) IBOutlet UILabel*     cellLabel;

@end
