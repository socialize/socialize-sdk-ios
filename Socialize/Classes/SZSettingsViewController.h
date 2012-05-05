//
//  SZSettingsViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeProfileEditValueViewController.h"
#import "SocializeBaseViewController.h"
#import "SZSettingsViewControllerDelegate.h"

@class SocializeProfileEditValueViewController;

typedef enum {
    SZSettingsViewControllerImageRowProfileImage,
    SZSettingsViewControllerNumImageRows,
} SZSettingsViewControllerImageRow;

typedef enum {
    SZSettingsViewControllerPropertiesRowFirstName,
    SZSettingsViewControllerPropertiesRowLastName,
    SZSettingsViewControllerPropertiesRowBio,
    SZSettingsViewControllerNumPropertiesRows,
} SZSettingsViewControllerPropertiesRow;

typedef enum {
    SZSettingsViewControllerFacebookRowPost,
    SZSettingsViewControllerFacebookRowLogout,
    SZSettingsViewControllerNumFacebookRows,
} SZSettingsViewControllerFacebookRow;

typedef enum {
    SZSettingsViewControllerTwitterRowPost,
    SZSettingsViewControllerTwitterRowLogout,
    SZSettingsViewControllerNumTwitterRows,
} SZSettingsViewControllerTwitterRow;

@class SocializeProfileEditTableViewImageCell;
@class SocializeProfileEditTableViewCell;
@class SocializeProfileEditValueViewController;

@interface SZSettingsViewController : SocializeBaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
@property (nonatomic, retain) id<SocializeFullUser> fullUser;
@property (nonatomic, retain) UIImage *profileImage;
@property (nonatomic, retain) NSArray *cellBackgroundColors;
@property (nonatomic, assign) id<SZSettingsViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIActionSheet *uploadPicActionSheet;
@property (nonatomic, retain) SocializeProfileEditValueViewController *editValueController;
@property (nonatomic, assign) IBOutlet SocializeProfileEditTableViewImageCell * profileImageCell;
@property (nonatomic, assign) IBOutlet SocializeProfileEditTableViewCell * profileTextCell;
@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) UISwitch *twitterSwitch;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL editOccured;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) NSMutableArray *facebookCells;
@property (nonatomic, retain) UIPopoverController *popover;

+ (UINavigationController*)profileEditViewControllerInNavigationController;
+ (SZSettingsViewController*)profileEditViewController;

- (NSString*)keyPathForPropertiesRow:(SZSettingsViewControllerPropertiesRow)row;
-(void) showActionSheet;

- (NSInteger)facebookSection;
- (NSInteger)twitterSection;
- (NSInteger)imageSection;
- (NSInteger)propertiesSection;

@end


