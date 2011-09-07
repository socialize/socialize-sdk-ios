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

@interface PostCommentViewController : UIViewController <UITextViewDelegate, MKMapViewDelegate, MKReverseGeocoderDelegate, SocializeServiceDelegate >
{

    NSString    *userLocationText;
    UITextView  *commentTextView;
    UILabel     *locationText;
    UIButton    *doNotShareLocationButton;
    UIButton    *activateLocationButton;
    CommentMapView *mapOfUserLocation;
    
    BOOL            shareLocation;
    BOOL            keyboardIsVisible;

    LoadingView*                          _loadingIndicatorView;
    Socialize*                            _socialize;
    NSString*                             _entityUrlString;
}

@property(nonatomic, retain) IBOutlet UITextView    *commentTextView;
@property(nonatomic, retain) IBOutlet UILabel       *locationText;
@property(nonatomic, retain) IBOutlet UIButton      *doNotShareLocationButton;
@property(nonatomic, retain) IBOutlet UIButton      *activateLocationButton;
@property(nonatomic, retain) IBOutlet CommentMapView *mapOfUserLocation;

-(IBAction)activateLocationButtonPressed:(id)sender;
-(IBAction)doNotShareLocationButtonPressed:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityUrlString:(NSString*)entityUrlString;

@end