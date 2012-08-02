//
//  _SZUserSettingsViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeProfileEditValueViewController.h"
#import "SocializeBaseViewController.h"
#import "_SZUserSettingsViewControllerDelegate.h"

@class SocializeProfileEditValueViewController;

typedef enum {
    _SZUserSettingsViewControllerImageRowProfileImage,
    _SZUserSettingsViewControllerNumImageRows,
} _SZUserSettingsViewControllerImageRow;

typedef enum {
    _SZUserSettingsViewControllerPropertiesRowFirstName,
    _SZUserSettingsViewControllerPropertiesRowLastName,
    _SZUserSettingsViewControllerPropertiesRowBio,
    _SZUserSettingsViewControllerNumPropertiesRows,
} _SZUserSettingsViewControllerPropertiesRow;

typedef enum {
    _SZUserSettingsViewControllerFacebookRowLoginLogout,
    _SZUserSettingsViewControllerFacebookRowPost,
    _SZUserSettingsViewControllerNumFacebookRows,
} _SZUserSettingsViewControllerFacebookRow;

typedef enum {
    _SZUserSettingsViewControllerTwitterRowLoginLogout,
    _SZUserSettingsViewControllerTwitterRowPost,
    _SZUserSettingsViewControllerNumTwitterRows,
} _SZUserSettingsViewControllerTwitterRow;

@class SocializeProfileEditTableViewImageCell;
@class SocializeProfileEditTableViewCell;
@class SocializeProfileEditValueViewController;

@interface _SZUserSettingsViewController : SocializeBaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
@property (nonatomic, assign) BOOL hideLogoutButtons;
@property (nonatomic, retain) id<SocializeFullUser> fullUser;
@property (nonatomic, retain) UIImage *profileImage;
@property (nonatomic, retain) NSArray *cellBackgroundColors;
@property (nonatomic, assign) id<_SZUserSettingsViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIActionSheet *uploadPicActionSheet;
@property (nonatomic, retain) SocializeProfileEditValueViewController *editValueController;
@property (nonatomic, retain) IBOutlet SocializeProfileEditTableViewImageCell * profileImageCell;
@property (nonatomic, retain) IBOutlet SocializeProfileEditTableViewCell * profileTextCell;
@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) UISwitch *twitterSwitch;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL editOccured;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) NSMutableArray *facebookCells;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, copy) void (^userSettingsCompletionBlock)(BOOL didSave, id<SZFullUser> user);
+ (UINavigationController*)profileEditViewControllerInNavigationController;
+ (_SZUserSettingsViewController*)profileEditViewController;
+ (_SZUserSettingsViewController*)settingsViewController;

- (NSString*)keyPathForPropertiesRow:(_SZUserSettingsViewControllerPropertiesRow)row;
-(void) showActionSheet;

- (NSInteger)facebookSection;
- (NSInteger)twitterSection;
- (NSInteger)imageSection;
- (NSInteger)propertiesSection;

@end


