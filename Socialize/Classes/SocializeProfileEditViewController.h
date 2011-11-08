//
//  SocializeProfileEditViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeProfileEditValueController.h"

@class SocializeProfileEditValueController;
typedef enum {
    SocializeProfileEditViewControllerSectionImage,
    SocializeProfileEditViewControllerSectionProperties,
    SocializeProfileEditViewControllerSectionPermissions,
    SocializeProfileEditViewControllerNumSections,
} SocializeProfileEditViewControllerSection;

typedef enum {
    SocializeProfileEditViewControllerImageRowProfileImage,
    SocializeProfileEditViewControllerNumImageRows,
} SocializeProfileEditViewControllerImageRow;

typedef enum {
    SocializeProfileEditViewControllerPropertiesRowFirstName,
    SocializeProfileEditViewControllerPropertiesRowLastName,
    SocializeProfileEditViewControllerPropertiesRowBio,
    SocializeProfileEditViewControllerNumPropertiesRows,
} SocializeProfileEditViewControllerPropertiesRow;

typedef enum {
    SocializeProfileEditViewControllerPermissionsRowFacebook,
    SocializeProfileEditViewControllerNumPermissionsRows,
} SocializeProfileEditViewControllerPermissionsRow;

@protocol SocializeProfileEditViewControllerDelegate;
@class SocializeProfileEditTableViewImageCell;
@class SocializeProfileEditTableViewCell;
@class SocializeProfileEditValueController;

@interface SocializeProfileEditViewController : UITableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SocializeProfileEditValueControllerDelegate>
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, retain) UIImage *profileImage;
@property (nonatomic, retain) NSArray *cellBackgroundColors;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, assign) id<SocializeProfileEditViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIActionSheet *uploadPicActionSheet;
@property (nonatomic, retain) SocializeProfileEditValueController *editValueController;
@property (nonatomic, assign) IBOutlet SocializeProfileEditTableViewImageCell * profileImageCell;
@property (nonatomic, assign) IBOutlet SocializeProfileEditTableViewCell * profileTextCell;
@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) NSUserDefaults *userDefaults;

- (NSString*)keyPathForPropertiesRow:(SocializeProfileEditViewControllerPropertiesRow)row;
-(void) showActionSheet;
@end

@protocol SocializeProfileEditViewControllerDelegate <NSObject>

- (void)profileEditViewControllerDidSave:(SocializeProfileEditViewController*)profileEditViewController;
- (void)profileEditViewControllerDidCancel:(SocializeProfileEditViewController*)profileEditViewController;

@end


