//
//  PostCommentViewController.h
//  appbuildr
//
//  Created by William M. Johnson on 4/5/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppMakrLoadingView.h"
//#import "MasterController.h"



@class CommentMapView;

@protocol PostCommentViewControllerDelegate;

@interface PostCommentViewController : UIViewController <UITextViewDelegate, MKMapViewDelegate, MKReverseGeocoderDelegate >
{

    NSString    *userLocationText;
    UITextView  *commentTextView;
    UILabel     *locationText;
    UIButton    *doNotShareLocationButton;
    UIButton    *activateLocationButton;
    CommentMapView *mapOfUserLocation;

    BOOL            shareLocation;
    BOOL            keyboardIsVisible;

    id<PostCommentViewControllerDelegate> delegate; 
    AppMakrLoadingView*                   _loadingIndicatorView;
   // CLLocationManager
    

}

@property(nonatomic, retain) IBOutlet UITextView    *commentTextView;
@property(nonatomic, retain) IBOutlet UILabel       *locationText;
@property(nonatomic, retain) IBOutlet UIButton      *doNotShareLocationButton;
@property(nonatomic, retain) IBOutlet UIButton      *activateLocationButton;
@property(nonatomic, retain) IBOutlet CommentMapView *mapOfUserLocation;
@property(nonatomic, assign) id<PostCommentViewControllerDelegate> delegate; 

-(IBAction)activateLocationButtonPressed:(id)sender;
-(IBAction)doNotShareLocationButtonPressed:(id)sender;

@end


@protocol PostCommentViewControllerDelegate 

-(void)postCommentController:(PostCommentViewController*) controller sendComment:(NSString*)commentText location:(CLLocation *)commentLocation shareLocation:(BOOL)shareLocation;

-(void)postCommentControllerCancell:(PostCommentViewController*) controller; 
@end
