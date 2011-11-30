//
//  SocializeProfileEditViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/1/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeProfileEditValueViewController.h"
#import "SocializeBaseViewController.h"

@class SocializeProfileEditValueViewController;
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
@class SocializeProfileEditValueViewController;

@interface SocializeProfileEditViewController : SocializeBaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SocializeProfileEditValueViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) id<SocializeFullUser> fullUser;
@property (nonatomic, retain) UIImage *profileImage;
@property (nonatomic, retain) NSArray *cellBackgroundColors;
@property (nonatomic, assign) id<SocializeProfileEditViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIActionSheet *uploadPicActionSheet;
@property (nonatomic, retain) SocializeProfileEditValueViewController *editValueController;
@property (nonatomic, assign) IBOutlet SocializeProfileEditTableViewImageCell * profileImageCell;
@property (nonatomic, assign) IBOutlet SocializeProfileEditTableViewCell * profileTextCell;
@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL editOccured;

+ (UINavigationController*)profileEditViewControllerInNavigationController;
+ (SocializeProfileEditViewController*)profileEditViewController;

- (NSString*)keyPathForPropertiesRow:(SocializeProfileEditViewControllerPropertiesRow)row;
-(void) showActionSheet;
@end

@protocol SocializeProfileEditViewControllerDelegate <NSObject>

- (void)profileEditViewController:(SocializeProfileEditViewController*)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user;
- (void)profileEditViewControllerDidCancel:(SocializeProfileEditViewController*)profileEditViewController;

@end


