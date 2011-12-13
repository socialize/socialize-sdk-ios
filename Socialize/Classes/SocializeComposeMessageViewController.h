//
//  PostCommentViewController.h
//  appbuildr
//
//  Created by William M. Johnson on 4/5/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "SocializeBaseViewController.h"
#import "_Socialize.h"
#import "SocializeProfileViewController.h"
@class CommentMapView;
@class SocializeLocationManager;
@protocol SocializeComposeMessageViewControllerDelegate;

@interface SocializeComposeMessageViewController : SocializeBaseViewController <UITextViewDelegate, MKMapViewDelegate, SocializeServiceDelegate>
{
    UITextView* commentTextView;
    UILabel*    locationText; 
    UIButton*   doNotShareLocationButton;
    UIButton*   activateLocationButton;
    CommentMapView* mapOfUserLocation;
    Class _geoCoderInfo;
}

@property (nonatomic, assign) id<SocializeComposeMessageViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *entityURL;
@property(nonatomic, retain) SocializeLocationManager *locationManager;
@property(nonatomic, retain) IBOutlet UITextView    *commentTextView;
@property(nonatomic, retain) IBOutlet UILabel       *locationText;
@property(nonatomic, retain) IBOutlet UIButton      *doNotShareLocationButton;
@property(nonatomic, retain) IBOutlet UIButton      *activateLocationButton;
@property(nonatomic, retain) IBOutlet CommentMapView *mapOfUserLocation;
@property(nonatomic, retain) IBOutlet UIView *lowerContainer;
@property(nonatomic, retain) IBOutlet UIView *upperContainer;
@property(nonatomic, retain) IBOutlet UIView *mapContainer;

-(IBAction)activateLocationButtonPressed:(id)sender;
-(IBAction)doNotShareLocationButtonPressed:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
      entityUrlString:(NSString*)entityUrlString;

- (void)addSocializeRoundedGrayButtonImagesToButton:(UIButton*)button;
- (void)setSubviewForLowerContainer:(UIView*)newSubview;

@end

@protocol SocializeComposeMessageViewControllerDelegate <NSObject>

- (void)composeMessageViewControllerDidCancel:(SocializeComposeMessageViewController*)composeMessageViewController;

@end