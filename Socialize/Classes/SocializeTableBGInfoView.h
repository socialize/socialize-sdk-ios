//
//  TableBGInfoView.h
//  appbuildr
//
//  Created by Fawad Haider  on 2/9/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SocializeTableBGInfoView : UIView {
	UIImageView		 *noActivityImageView;
	UILabel			 *errorLabel;
}

@property (nonatomic, retain) UIImageView* noActivityImageView;
@property (nonatomic, retain) UILabel*	   errorLabel;
- (id)initWithFrame:(CGRect)frame bgImageName:(NSString*)bgImageName;
@end
