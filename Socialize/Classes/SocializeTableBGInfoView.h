//
//  TableBGInfoView.h
//  appbuildr
//
//  Created by Fawad Haider  on 2/9/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat SocializeTableBGInfoViewDefaultWidth;
extern CGFloat SocializeTableBGInfoViewDefaultHeight;

@interface SocializeTableBGInfoView : UIView {
	UILabel			 *errorLabel;
}

@property (nonatomic, retain) UILabel*	   errorLabel;
- (id)initWithFrame:(CGRect)frame bgImageName:(NSString*)bgImageName;
@end
