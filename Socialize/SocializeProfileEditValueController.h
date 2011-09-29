//
//  ProfileEditValueController.h
//  appbuildr
//
//  Created by William Johnson on 1/11/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeEditValueTableViewCell.h"

@interface SocializeProfileEditValueController : UITableViewController <UITextFieldDelegate>
{

	SocializeEditValueTableViewCell * editValueCell;
	UITextField * editValueField;
	NSIndexPath * indexPath;
	NSString * valueToEdit;
	
	BOOL didEdit;
}
@property (nonatomic, assign) BOOL didEdit;
@property (nonatomic, assign) IBOutlet SocializeEditValueTableViewCell * editValueCell;
@property (nonatomic, assign) IBOutlet UITextField * editValueField;
@property (nonatomic, retain) NSIndexPath * indexPath;
@property (nonatomic, retain) NSString * valueToEdit;

@end
