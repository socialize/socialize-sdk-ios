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
#import "SocializeBaseViewControllerDelegate.h"
#import "SocializeLocationManager.h"

@class CommentMapView;
@class SocializeHorizontalContainerView;

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

@property (nonatomic, copy) NSString *entityURL;
@property(nonatomic, retain) IBOutlet UITextView    *commentTextView;
@property(nonatomic, retain) IBOutlet UILabel       *locationText;
@property(nonatomic, retain) IBOutlet UIButton      *doNotShareLocationButton;
@property(nonatomic, retain) IBOutlet UIButton      *activateLocationButton;
@property(nonatomic, retain) IBOutlet CommentMapView *mapOfUserLocation;
@property(nonatomic, retain) IBOutlet UIView *lowerContainer;
@property(nonatomic, retain) IBOutlet UIView *upperContainer;
@property(nonatomic, retain) IBOutlet UIView *mapContainer;
@property(nonatomic, retain) UIBarButtonItem *sendButton;
@property(nonatomic, retain) IBOutlet SocializeHorizontalContainerView *messageActionButtonContainer;
@property(nonatomic, retain) NSArray *messageActionButtons;
@property(nonatomic, copy) NSString *currentLocationDescription;
@property (nonatomic, retain) SocializeLocationManager *locationManager;

-(IBAction)activateLocationButtonPressed:(id)sender;
-(IBAction)doNotShareLocationButtonPressed:(id)sender;

- (id)initWithEntityUrlString:(NSString*)entityUrlString;

- (void)addSocializeRoundedGrayButtonImagesToButton:(UIButton*)button;
- (void)setSubviewForLowerContainer:(UIView*)newSubview;

@end

