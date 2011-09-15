//
//  PostCommentViewController.h
//  appbuildr
//
//  Created by William M. Johnson on 4/5/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LoadingView.h"
#import "Socialize.h"

@class CommentMapView;
@class UIKeyboardListener;
@class SocializeLocationManager;

@interface PostCommentViewController : UIViewController <UITextViewDelegate, MKMapViewDelegate, SocializeServiceDelegate >
{
@private
    SocializeLocationManager* locationManager;
    UIKeyboardListener* kbListener;
    
    Socialize*  _socialize;
    NSString*   _entityUrlString;
    
    UITextView* commentTextView;
    UILabel*    locationText; 
    UIButton*   doNotShareLocationButton;
    UIButton*   activateLocationButton;
    CommentMapView* mapOfUserLocation;
    LoadingView*  _loadingIndicatorView;
}

@property(nonatomic, retain) IBOutlet UITextView    *commentTextView;
@property(nonatomic, retain) IBOutlet UILabel       *locationText;
@property(nonatomic, retain) IBOutlet UIButton      *doNotShareLocationButton;
@property(nonatomic, retain) IBOutlet UIButton      *activateLocationButton;
@property(nonatomic, retain) IBOutlet CommentMapView *mapOfUserLocation;
@property(nonatomic, retain) Socialize* socialize;

-(IBAction)activateLocationButtonPressed:(id)sender;
-(IBAction)doNotShareLocationButtonPressed:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityUrlString:(NSString*)entityUrlString keyboardListener:(UIKeyboardListener*)kb locationManager:(SocializeLocationManager*) lManager;

+(UINavigationController*)createAndShowPostViewControllerWithEntityUrl:(NSString*)url andImageForNavBar: (UIImage*)imageForBar;

@end