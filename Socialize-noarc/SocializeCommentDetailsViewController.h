//
//  CommentDetailsViewController.h
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SocializeBaseViewController.h"
#import "AvailabilityMacros.h"
#import "SocializeBaseViewController.h"
#import "_SZUserProfileViewController.h"

@class CommentDetailsView;
@class URLDownload;
@protocol SocializeComment;
@class ImagesCache;
@protocol _SZUserProfileViewControllerDelegate;

 __attribute__((deprecated))
@interface SocializeCommentDetailsViewController : SocializeBaseViewController<SocializeBaseViewControllerDelegate>
{
    @private
        CommentDetailsView*     commentDetailsView;
        id<SocializeComment>    comment;
        ImagesCache*            cache;
}
-(IBAction)profileButtonTapped:(id)sender;
-(void) showComment;
-(void) setupCommentGeoLocation;
-(void) showShareLocation:(BOOL)hasLocation;
-(_SZUserProfileViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;


@property (nonatomic, retain) IBOutlet CommentDetailsView*     commentDetailsView;
@property (nonatomic, retain) IBOutlet UIButton*     profileLabelButton;
@property (nonatomic, retain) id<SocializeComment>    comment;
@property (nonatomic, retain) URLDownload* profileImageDownloader;
@property (nonatomic, retain) ImagesCache*  cache;

@end
