//
//  SocializeActivityDetailsView.h
//  Socialize SDK
//
//  Created by Isaac Mosquera on 12/6/11.
//  Copyright 2011 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol SocializeActivityDetailsViewDelegate;
@protocol SocializeActivity;

@class HtmlPageCreator;
@interface SocializeActivityDetailsView : UIView <UIWebViewDelegate> {
@private
    IBOutlet UIWebView*         activityMessageView;
    IBOutlet UIButton*          profileNameButton;
    IBOutlet UIImageView*       profileImage;
    IBOutlet UIView*            recentActivityView;
    IBOutlet UILabel*           recentActivityLabel;
    NSString*                   activityMessage;
    NSDate*                     activityDate;
    NSString*                   username;
    NSDateFormatter*            dateFormatter;
    HtmlPageCreator*            htmlPageCreator;
}

@property (nonatomic, assign) IBOutlet id<SocializeActivityDetailsViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWebView*       activityMessageView; 
@property (nonatomic, retain) IBOutlet UIButton*        profileNameButton;
@property (nonatomic, retain) IBOutlet UIImageView*     profileImage;
@property (nonatomic, retain) IBOutlet UIView *showEntityView;
@property (nonatomic, retain) IBOutlet UIButton *showEntityButton;
/* recent activity view is a container view for the tableview and headers */
@property (nonatomic, retain) UIView *                  recentActivityView;
@property (nonatomic, retain) IBOutlet UIImageView *    recentActivityHeaderImage;
@property (nonatomic, retain) UILabel*                  recentActivityLabel;
@property (nonatomic, retain) NSString*                 activityMessage;
@property (nonatomic, retain) NSDate*                   activityDate;
@property (nonatomic, retain) id<SocializeActivity> activity;
@property (nonatomic, retain) NSString*                 username;
@property (nonatomic, retain) NSDateFormatter*          dateFormatter;
@property (nonatomic, retain) HtmlPageCreator*          htmlPageCreator;
@property (nonatomic, retain) IBOutlet UILabel *locationTextLabel;
@property (nonatomic, retain) IBOutlet UIButton *locationPinButton;
@property (nonatomic, retain) IBOutlet UIButton *locationFatButton;

-(void) updateProfileImage: (UIImage* )image;
-(void) updateActivityMessageView;
-(void) layoutActivityDetailsSubviews;
-(void) updateActivityMessage:(NSString *)newActivityMessage withActivityDate:(NSDate *)newActivityDate;

@end

@protocol SocializeActivityDetailsViewDelegate <NSObject>

- (void)activityDetailsViewDidFinishLoad:(SocializeActivityDetailsView*)activityDetailsView;

@end