//
//  CommentDetailsView.h
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CommentMapView;

@interface SocializeActivityDetailsView : UIScrollView <UIWebViewDelegate> {
@private
    IBOutlet UIWebView*         activityMessageView;
    IBOutlet UIButton*          profileNameButton;
    IBOutlet UIImageView*       profileImage;
    IBOutlet UIView*            recentActivityView;
    IBOutlet UIImageView*       recentActivityHeaderImage;
    UIView*                     activityTableView;
    NSString*                   activityMessage;
    NSDate*                     activityDate;
    NSString*                   username;
}

@property (nonatomic, retain) IBOutlet UIWebView* activityMessageView; 
@property (nonatomic, retain) IBOutlet UIButton* profileNameButton;
@property (nonatomic, retain) IBOutlet UIImageView* profileImage;
/* recent activity view is a container view for the tableview and headers */
@property (nonatomic, retain) UIView * recentActivityView;
@property (nonatomic, retain) UIView * activityTableView;
@property (nonatomic, retain) UIView * recentActivityHeaderImage;
@property (nonatomic, retain) NSString * activityMessage;
@property (nonatomic, retain) NSDate* activityDate;
@property (nonatomic, retain) NSString *username;
-(void) updateProfileImage: (UIImage* )image;
-(void) updateActivityMessageView;
-(void) layoutRecentActivitySubviews;
-(void) layoutActivityDetailsSubviews;
-(void)updateActivityMessage:(NSString *)newActivityMessage withActivityDate:(NSDate *)newActivityDate;

@end