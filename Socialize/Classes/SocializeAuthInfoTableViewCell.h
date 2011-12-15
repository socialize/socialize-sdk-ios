//
//  AuthorizeInfoTableViewCell.h
//  appbuildr
//
//  Created by Fawad Haider  on 5/23/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SocializeAuthInfoTableViewCell : UITableViewCell {
    UIImageView* cellIcon;
    UILabel*     cellLabel;
    UILabel*     cellSubLabel;
}

@property (retain, nonatomic) IBOutlet UIImageView* cellIcon;  
@property (retain, nonatomic) IBOutlet UILabel*     cellLabel;
@property (retain, nonatomic) IBOutlet UILabel*     cellSubLabel;

@end
