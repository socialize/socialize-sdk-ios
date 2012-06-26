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
#import "SocializeActivityDetailsViewControllerDelegate.h"

@class CommentDetailsView;
@class URLDownload;
@protocol SocializeActivity;
@class ImagesCache;
@protocol SocializeActivityDetailsViewControllerDelegate;

@interface SocializeActivityDetailsViewController : SocializeBaseViewController <SocializeActivityViewControllerDelegate, SocializeActivityDetailsViewDelegate>
-(id)initWithActivity:(id<SocializeActivity>)socializeActivity;
-(id)init;
-(void)fetchActivityForType:(NSString*)activityType activityID:(NSNumber*)activityID;
-(void)configureDetailsView;
- (IBAction)showEntityButtonPressed:(id)sender;
- (IBAction)locationButtonPressed:(id)sender;

@property (nonatomic, retain) IBOutlet SocializeActivityDetailsView*     activityDetailsView;
@property (nonatomic, retain) id<SocializeActivity> socializeActivity;
/** this view controller shows all the recent activity for a given user */
@property (nonatomic, retain) IBOutlet SocializeActivityViewController*  activityViewController;
@property (nonatomic, assign) id <SocializeActivityDetailsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *currentLocationDescription;
@end

