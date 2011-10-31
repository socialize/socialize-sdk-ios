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
@class UIKeyboardListener;
@class SocializeLocationManager;

@interface SocializePostCommentViewController : SocializeBaseViewController <UITextViewDelegate, MKMapViewDelegate, SocializeServiceDelegate, UIAlertViewDelegate, SocializeProfileViewControllerDelegate >
{
@private
    SocializeLocationManager* locationManager;
    UIKeyboardListener* kbListener;
    
    NSString*   _entityUrlString;
    
    UITextView* commentTextView;
    UILabel*    locationText; 
    UIButton*   doNotShareLocationButton;
    UIButton*   activateLocationButton;
    CommentMapView* mapOfUserLocation;
    Class _geoCoderInfo;
    
    UIAlertView *_facebookAuthQuestionDialog;
}

@property(nonatomic, retain) IBOutlet UITextView    *commentTextView;
@property(nonatomic, retain) IBOutlet UILabel       *locationText;
@property(nonatomic, retain) IBOutlet UIButton      *doNotShareLocationButton;
@property(nonatomic, retain) IBOutlet UIButton      *activateLocationButton;
@property(nonatomic, retain) IBOutlet CommentMapView *mapOfUserLocation;
@property(nonatomic, retain) UIAlertView *facebookAuthQuestionDialog;
@property(nonatomic, retain) IBOutlet UIView *locationViewContainer;
@property(nonatomic, retain) IBOutlet UIView *mapContainer;

-(IBAction)activateLocationButtonPressed:(id)sender;
-(IBAction)doNotShareLocationButtonPressed:(id)sender;
- (void)createComment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityUrlString:(NSString*)entityUrlString keyboardListener:(UIKeyboardListener*)kb locationManager:(SocializeLocationManager*) lManager geocoderInfo:(Class)geocoderInfo;

+(UINavigationController*)createNavigationControllerWithPostViewControllerOnRootWithEntityUrl:(NSString*)url andImageForNavBar: (UIImage*)imageForBar;

@end