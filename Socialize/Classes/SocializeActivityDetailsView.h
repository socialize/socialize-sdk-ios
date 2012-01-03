//
//  SocializeActivityDetailsView.h
//  Socialize SDK
//
//  Created by Isaac Mosquera on 12/6/11.
//  Copyright 2011 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class HtmlPageCreator;
@interface SocializeActivityDetailsView : UIScrollView <UIWebViewDelegate> {
@private
    IBOutlet UIWebView*         activityMessageView;
    IBOutlet UIButton*          profileNameButton;
    IBOutlet UIImageView*       profileImage;
    IBOutlet UIView*            recentActivityView;
    IBOutlet UILabel*           recentActivityLabel;
    IBOutlet UIImageView*       recentActivityHeaderImage;
    UIView*                     activityTableView;
    NSString*                   activityMessage;
    NSDate*                     activityDate;
    NSString*                   username;
    NSDateFormatter*            dateFormatter;
    HtmlPageCreator*            htmlPageCreator;
}

@property (nonatomic, retain) IBOutlet UIWebView*       activityMessageView; 
@property (nonatomic, retain) IBOutlet UIButton*        profileNameButton;
@property (nonatomic, retain) IBOutlet UIImageView*     profileImage;
/* recent activity view is a container view for the tableview and headers */
@property (nonatomic, retain) UIView *                  recentActivityView;
@property (nonatomic, retain) UIView *                  activityTableView;
@property (nonatomic, retain) UIView *                  recentActivityHeaderImage;
@property (nonatomic, retain) UILabel*                  recentActivityLabel;
@property (nonatomic, retain) NSString*                 activityMessage;
@property (nonatomic, retain) NSDate*                   activityDate;
@property (nonatomic, retain) NSString*                 username;
@property (nonatomic, retain) NSDateFormatter*          dateFormatter;
@property (nonatomic, retain) HtmlPageCreator*          htmlPageCreator;

-(void) updateProfileImage: (UIImage* )image;
-(void) updateActivityMessageView;
-(void) layoutRecentActivitySubviews;
-(void) layoutActivityDetailsSubviews;
-(void) updateActivityMessage:(NSString *)newActivityMessage withActivityDate:(NSDate *)newActivityDate;

@end