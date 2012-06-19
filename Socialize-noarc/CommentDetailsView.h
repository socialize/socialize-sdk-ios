//
//  CommentDetailsView.h
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CommentMapView;

@interface CommentDetailsView : UIScrollView <UIWebViewDelegate> {
@private
    IBOutlet UIWebView*         commentMessage;
    IBOutlet CommentMapView*    mapOfUserLocation;
    IBOutlet UIImageView*       navImage;
    IBOutlet UILabel*           positionLable;
    IBOutlet UIButton*          profileNameButton;
    IBOutlet UIImageView*       profileImage;
    IBOutlet UIImageView*       shadowBackground;
    IBOutlet UIView*            shadowMapOfUserLocation;
    BOOL                        showMap;
}

@property (nonatomic, retain) IBOutlet UIWebView* commentMessage; 
@property (nonatomic, retain) IBOutlet CommentMapView* mapOfUserLocation;
@property (nonatomic, retain) IBOutlet UIImageView* navImage;
@property (nonatomic, retain) IBOutlet UILabel* positionLable;
@property (nonatomic, retain) IBOutlet UIButton* profileNameButton;
@property (nonatomic, retain) IBOutlet UIImageView* profileImage;
@property (nonatomic, retain) IBOutlet UIImageView* shadowBackground;
@property (nonatomic, retain) IBOutlet UIView * shadowMapOfUserLocation;
@property (nonatomic, assign) BOOL showMap;

-(void) updateProfileImage: (UIImage* )image;
-(void) updateLocationText: (NSString*)text;
-(void) updateLocationText: (NSString*)text color: (UIColor*) color fontName: (NSString*) font fontSize: (CGFloat)size;
-(void) updateNavigationImage: (UIImage*)image;
-(void) updateUserName: (NSString*)name;
-(void) updateGeoLocation: (CLLocationCoordinate2D)location;
-(void) updateCommentMsg: (NSString*)comment;
-(void) configurateView;

@end