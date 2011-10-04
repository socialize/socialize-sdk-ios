//
//  ProfileEditViewController.h
//  appbuildr
//
//  Created by William Johnson on 1/10/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeUser.h"

@class SocializeProfileEditTableViewCell;
@class SocializeProfileEditValueController;
@protocol SocializeProfileEditViewControllerDelegate;

@interface SocializeProfileEditViewController : UITableViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate>
{

	id<SocializeProfileEditViewControllerDelegate> delegate;
	NSArray						*keysToEdit;
	NSMutableDictionary		   *keyValueDictionary;
	SocializeProfileEditTableViewCell   *profileEditViewCell;
	SocializeProfileEditValueController *editValueViewController;
	UIImage					*profileImage;
	UIImagePickerController *imagePicker;
	NSArray					*cellBackgroundColors;
}

@property (nonatomic, assign) id<SocializeProfileEditViewControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet SocializeProfileEditTableViewCell * profileEditViewCell;
@property (nonatomic, retain) NSArray * keysToEdit;
@property (nonatomic, retain) NSMutableDictionary * keyValueDictionary;
@property (nonatomic, readonly) UIImage * profileImage;

-(void)setProfileImage:(UIImage *) profileImage;
-(void)updateDidFailWithError:(NSError *)error;

@end


@protocol  SocializeProfileEditViewControllerDelegate
-(void)profileEditViewController:(SocializeProfileEditViewController*)controller didFinishWithError:(NSError*)error;
-(void)profileEditViewControllerDidCancel:(SocializeProfileEditViewController*)controller;
@end