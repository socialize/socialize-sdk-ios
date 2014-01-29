//
//  ComposeCommentViewController.h
//  appbuildr
//
//  Created by William M. Johnson on 4/5/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "SocializeBaseViewController.h"
#import "_Socialize.h"
#import "_SZUserProfileViewController.h"
#import "SocializeBaseViewControllerDelegate.h"

@class SocializeLocationManager;
@class CommentMapView;
@class SZHorizontalContainerView;

@interface SocializeComposeMessageViewController : SocializeBaseViewController <UITextViewDelegate, MKMapViewDelegate, SocializeServiceDelegate>
{
    UITextView* commentTextView;
    UILabel*    locationText; 
    UIButton*   doNotShareLocationButton;
    UIButton*   activateLocationButton;
    CommentMapView* mapOfUserLocation;
    Class _geoCoderInfo;
    NSArray *messageActionButtons_;
}

@property (nonatomic, retain) id<SZEntity> entity;
@property(nonatomic, retain) IBOutlet UITextView    *commentTextView;
@property(nonatomic, retain) IBOutlet UILabel       *locationText;
@property(nonatomic, retain) IBOutlet UIButton      *doNotShareLocationButton;
@property(nonatomic, retain) IBOutlet UIButton      *activateLocationButton;
@property(nonatomic, retain) IBOutlet CommentMapView *mapOfUserLocation;
@property(nonatomic, retain) IBOutlet UIView *lowerContainer;
@property(nonatomic, retain) IBOutlet UIView *upperContainer;
@property(nonatomic, retain) IBOutlet UIView *mapContainer;
@property(nonatomic, retain) UIBarButtonItem *sendButton;
@property(nonatomic, retain) IBOutlet SZHorizontalContainerView *messageActionButtonContainer;
@property(nonatomic, retain) NSArray *messageActionButtons;
@property(nonatomic, copy) NSString *currentLocationDescription;
@property (nonatomic, retain) SocializeLocationManager *locationManager;
@property (retain, nonatomic) IBOutlet UIView *bottomContainerDisabledView;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) BOOL shouldShareLocation;
@property (nonatomic, retain) NSString *initialText;
@property (nonatomic, assign) BOOL allowEmpty;
@property (retain, nonatomic) IBOutlet UIView *mapViewContainer;

- (void)disableLowerContainer;
- (void)enableLowerContainer;

-(IBAction)activateLocationButtonPressed:(id)sender;
-(IBAction)doNotShareLocationButtonPressed:(id)sender;

- (id)initWithEntityUrlString:(NSString*)entityUrlString;
- (id)initWithEntity:(id<SZEntity>)entity;

- (void)addSocializeGrayButtonLook:(UIButton*)button;
- (void)setSubviewForLowerContainer:(UIView*)newSubview;

- (void)stopReverseGeocodeTimer;

@end

