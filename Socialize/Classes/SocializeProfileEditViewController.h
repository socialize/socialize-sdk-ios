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
#import "SocializeProfileEditViewControllerDelegate.h"

@class SocializeProfileEditValueViewController;

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
    SocializeProfileEditViewControllerFacebookRowPost,
    SocializeProfileEditViewControllerFacebookRowLogout,
    SocializeProfileEditViewControllerNumFacebookRows,
} SocializeProfileEditViewControllerFacebookRow;

typedef enum {
    SocializeProfileEditViewControllerTwitterRowPost,
    SocializeProfileEditViewControllerTwitterRowLogout,
    SocializeProfileEditViewControllerNumTwitterRows,
} SocializeProfileEditViewControllerTwitterRow;

@class SocializeProfileEditTableViewImageCell;
@class SocializeProfileEditTableViewCell;
@class SocializeProfileEditValueViewController;

@interface SocializeProfileEditViewController : SocializeBaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
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
@property (nonatomic, retain) UISwitch *twitterSwitch;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL editOccured;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) NSMutableArray *facebookCells;

+ (UINavigationController*)profileEditViewControllerInNavigationController;
+ (SocializeProfileEditViewController*)profileEditViewController;

- (NSString*)keyPathForPropertiesRow:(SocializeProfileEditViewControllerPropertiesRow)row;
-(void) showActionSheet;

- (NSInteger)facebookSection;
- (NSInteger)twitterSection;
- (NSInteger)imageSection;
- (NSInteger)propertiesSection;

@end


