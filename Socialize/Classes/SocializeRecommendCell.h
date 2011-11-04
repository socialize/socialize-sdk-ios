//
//  SocializeRecommendCell.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocializeRecommendCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentsCount;
@property (nonatomic, retain) IBOutlet UILabel *likesCount;
@property (nonatomic, retain) IBOutlet UILabel *sharesCount;
@property (nonatomic, retain) IBOutlet UILabel *viewsCount;
@property (nonatomic, retain) IBOutlet UIImageView *bgImage;

@end
