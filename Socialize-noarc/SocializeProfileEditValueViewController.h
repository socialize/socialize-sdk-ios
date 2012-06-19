//
//  ProfileEditValueController.h
//  appbuildr
//
//  Created by William Johnson on 1/11/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeBaseViewController.h"

@class SocializeEditValueTableViewCell;

@interface SocializeProfileEditValueViewController : SocializeBaseViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL didEdit;
@property (nonatomic, assign) IBOutlet SocializeEditValueTableViewCell * editValueCell;
@property (nonatomic, assign) IBOutlet UITextField * editValueField;
@property (nonatomic, retain) NSIndexPath * indexPath;
@property (nonatomic, retain) NSString * valueToEdit;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) UIView *tableHeaderView;
@end

