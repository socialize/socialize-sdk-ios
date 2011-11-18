//
//  ProfileEditValueController.h
//  appbuildr
//
//  Created by William Johnson on 1/11/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocializeEditValueTableViewCell;
@protocol SocializeProfileEditValueViewControllerDelegate;

@interface SocializeProfileEditValueViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, assign) BOOL didEdit;
@property (nonatomic, assign) IBOutlet SocializeEditValueTableViewCell * editValueCell;
@property (nonatomic, assign) IBOutlet UITextField * editValueField;
@property (nonatomic, retain) NSIndexPath * indexPath;
@property (nonatomic, retain) NSString * valueToEdit;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, assign) id<SocializeProfileEditValueViewControllerDelegate> delegate;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) UIView *tableHeaderView;
@end

@protocol SocializeProfileEditValueViewControllerDelegate <NSObject>
- (void)profileEditValueViewControllerDidSave:(SocializeProfileEditValueViewController*)profileEditValueViewController;
- (void)profileEditValueViewControllerDidCancel:(SocializeProfileEditValueViewController*)profileEditValueViewController;
@end