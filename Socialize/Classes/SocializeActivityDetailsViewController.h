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
#import "SocializeActivityDetailsView.h"
#import "SocializeActivityViewController.h"

@class CommentDetailsView;
@class URLDownload;
@protocol SocializeActivity;
@class ImagesCache;
@protocol SocializeActivityDetailsViewControllerDelegate;

@interface SocializeActivityDetailsViewController : SocializeBaseViewController <SocializeActivityViewControllerDelegate>
-(id)initWithActivity:(id<SocializeActivity>)socializeActivity;
-(id)init;
-(void)fetchActivityForType:(NSString*)activityType activityID:(NSNumber*)activityID;
-(void)configureDetailsView;
- (IBAction)showEntityButtonPressed:(id)sender;

@property (nonatomic, retain) IBOutlet SocializeActivityDetailsView*     activityDetailsView;
@property (nonatomic, retain) id<SocializeActivity> socializeActivity;
/** this view controller shows all the recent activity for a given user */
@property (nonatomic, retain) SocializeActivityViewController*  activityViewController;
@property (nonatomic, assign) id <SocializeActivityDetailsViewControllerDelegate> delegate;


@end

@protocol SocializeActivityDetailsViewControllerDelegate <NSObject>
@optional
- (void)activityDetailsViewControllerDidDismiss:(SocializeActivityDetailsViewController*)activityDetailsViewController;
- (void)activityDetailsViewController:(SocializeActivityDetailsViewController*)activityDetailsViewController didLoadActivity:(id<SocializeActivity>)activity;

@end
