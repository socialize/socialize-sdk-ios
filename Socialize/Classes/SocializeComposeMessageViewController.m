//
//  PostCommentViewController.m
//  appbuildr
//
//  Created by William M. Johnson on 4/5/11.
//  Copyright 2011 pointabout. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SocializeComposeMessageViewController.h"
#import "UIButton+Socialize.h"
#import "CommentMapView.h"
#import "_Socialize.h"
#import "SocializeLocationManager.h"
#import "UILabel+FormatedText.h"
#import "UINavigationBarBackground.h"
#import "SocializeProfileViewController.h"
#import "SocializeAuthenticateService.h"
#import "SocializeGeocoderAdapter.h"
#import "NSString+PlaceMark.h"
#import "SocializeFacebookInterface.h"
#import "SocializeShareBuilder.h"
#import "SocializePrivateDefinitions.h"

#define NO_CITY_MSG @"Could not locate the place name."

#define PORTRAIT_KEYBOARD_HEIGHT 216
#define LANDSCAPE_KEYBOARD_HEIGHT 162

@interface SocializeComposeMessageViewController ()

-(void)setShareLocation:(BOOL)enableLocation;
-(void)configureLocationText; 
-(void)configureDoNotShareLocationButton;
-(void)updateViewWithNewLocation: (CLLocation*)userLocation;

@end 

@implementation SocializeComposeMessageViewController

@synthesize commentTextView;
@synthesize locationText;
@synthesize doNotShareLocationButton;
@synthesize activateLocationButton;
@synthesize mapOfUserLocation;
@synthesize mapContainer = _mapContainer;
@synthesize locationManager = _locationManager;
@synthesize entityURL = _entityURL;
@synthesize delegate = delegate_;
@synthesize lowerContainer = lowerContainer_;
@synthesize upperContainer = upperContainer_;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
      entityUrlString:(NSString*)entityUrlString 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.entityURL = entityUrlString;
    }
    return self;
}

- (void)dealloc
{
    [commentTextView release];
    [doNotShareLocationButton release];
    [activateLocationButton release];
    [mapOfUserLocation release];
    [locationText release];
    [_entityURL release];
    [_locationManager release];
    [_geoCoderInfo release];
    [_mapContainer release];
    [lowerContainer_ release];
    [upperContainer_ release];

    [super dealloc];
}

- (SocializeLocationManager*)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[SocializeLocationManager create] retain];
    }
    
    return _locationManager;
}

#pragma Location enable/disable button callbacks
-(void) startLoadAnimationForView: (UIView*) view
{
    [super startLoadAnimationForView:view];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void) stopLoadAnimation
{
    [super  stopLoadAnimation];
    self.navigationItem.rightBarButtonItem.enabled = YES; 
}

-(void)updateViewWithNewLocation: (CLLocation*)userLocation
{   
    if (userLocation) {
        
        [mapOfUserLocation setFitLocation: userLocation.coordinate withSpan: [CommentMapView coordinateSpan]];
        
        __block id geocoder = [[SocializeGeocoderAdapter alloc]init];
        
        [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray*placemarks, NSError *error)
         {
             if(error)
             {
//                 NSLog(@"reverseGeocoder didFailWithError:%@", error);
                 self.locationManager.currentLocationDescription = NO_CITY_MSG;
             }
             else
             {
                 self.locationManager.currentLocationDescription = [NSString stringWithPlacemark:[placemarks objectAtIndex:0]];
             }
             [self configureLocationText];
             [geocoder autorelease];
         }
         ];
    }
}

-(void)configureLocationText
{
    if (self.locationManager.shouldShareLocation) {
        [self.locationText text: self.locationManager.currentLocationDescription 
                   withFontName: @"Helvetica" 
                   withFontSize: 12.0 
                      withColor: [UIColor colorWithRed:(35.0/255) green:(130.0/255) blue:(210.0/255) alpha:1]
         ];
    }
    else {
        [self.locationText text: @"Location will not be shared." 
                   withFontName: @"Helvetica-Oblique" 
                   withFontSize: 12.0 
                      withColor: [UIColor colorWithRed:(167.0/255) green:(167.0/255) blue:(167.0/255) alpha:1]
         ];
    }
}

- (void)addSocializeRoundedGrayButtonImagesToButton:(UIButton*)button {
    UIImage * normalImage = [[UIImage imageNamed:@"socialize-comment-button.png"]stretchableImageWithLeftCapWidth:14 topCapHeight:0] ;
    UIImage * highlightImage = [[UIImage imageNamed:@"socialize-comment-button-active.png"]stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
	[button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
}

-(void)configureDoNotShareLocationButton
{   
    [self addSocializeRoundedGrayButtonImagesToButton:self.doNotShareLocationButton];
}

-(void)setShareLocation:(BOOL)enableLocation 
{   
    self.locationManager.shouldShareLocation = enableLocation;
    if (enableLocation) {
        if (![self.locationManager applicationIsAuthorizedToUseLocationServices])
        {
            [self showAlertWithText:@"Please Turn On Location Services in Settings to Allow This Application to Share Your Location." andTitle:nil];
            return;
        }
       
        [activateLocationButton setImage:[UIImage imageNamed:@"socialize-comment-location-enabled.png"] forState:UIControlStateNormal];
        [activateLocationButton setImage:[UIImage imageNamed:@"socialize-comment-location-enabled.png"] forState:UIControlStateHighlighted];
        
    }
    else
    {   
        [activateLocationButton setImage:[UIImage imageNamed:@"socialize-comment-location-disabled.png"] forState:UIControlStateNormal];
        [activateLocationButton setImage:[UIImage imageNamed:@"socialize-comment-location-disabled.png"] forState:UIControlStateHighlighted];   
    }
    
    [self configureLocationText];
}

#pragma mark - Buttons actions

- (void)setSubviewForLowerContainer:(UIView*)newSubview {
    for (UIView *view in self.lowerContainer.subviews) {
        [view removeFromSuperview];
    }
    
    [self.lowerContainer addSubview:newSubview];
    CGRect lowerFrame = self.lowerContainer.frame;
    newSubview.frame = CGRectMake(0, 0, lowerFrame.size.width, lowerFrame.size.height);
}

-(IBAction)activateLocationButtonPressed:(id)sender
{
    if (self.locationManager.shouldShareLocation)
    {
        if ([commentTextView isFirstResponder]) 
        {
            [commentTextView resignFirstResponder];          
            [self setSubviewForLowerContainer:self.mapContainer];
        }
        else
        {
            [commentTextView becomeFirstResponder];
        }            
    }
    else
    {
        [self setShareLocation:YES];
        [self setSubviewForLowerContainer:self.mapContainer];
    }
}

-(IBAction)doNotShareLocationButtonPressed:(id)sender
{  
    [self setShareLocation:NO];
    [commentTextView becomeFirstResponder];
}

-(void)cancelButtonPressed:(UIButton*)button {
    [self stopLoadAnimation];
    
    if ([self.delegate respondsToSelector:@selector(composeMessageViewControllerDidCancel:)]) {
        [self.delegate composeMessageViewControllerDidCancel:self];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - SocializeServiceDelegate

-(void)service:(SocializeService *)service didFail:(NSError *)error
{
    if([service isKindOfClass:[SocializeAuthenticateService class]])
    {
        [super service:service didFail:error];
    }
    else
    {   
        [self stopLoadAnimation];
        [self showAlertWithText:[error localizedDescription] andTitle:@"Post comment"];  
    }
}

#pragma mark - UITextViewDelegate callbacks

-(void)textViewDidChange:(UITextView *)textView {
    if ([commentTextView.text length] > 0) 
      self.navigationItem.rightBarButtonItem.enabled = YES;     
    else
      self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.navigationItem.rightBarButtonItem = self.sendButton;
    self.sendButton.enabled = NO;
    
    [self.commentTextView becomeFirstResponder];    
    
    [self setShareLocation:self.locationManager.shouldShareLocation];
    
    [self.mapOfUserLocation roundCorners];
    [self configureDoNotShareLocationButton];       
    [self updateViewWithNewLocation: mapOfUserLocation.userLocation.location];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
        
    self.commentTextView = nil;
    self.locationText = nil;
    self.doNotShareLocationButton = nil;
    self.activateLocationButton = nil;
    self.mapOfUserLocation = nil;
    self.mapContainer = nil;
    self.lowerContainer = nil;
    self.upperContainer = nil;
}

- (UIView*)showLoadingInView {
    return commentTextView;
}

- (void)keyboardListener:(SocializeKeyboardListener *)keyboardListener keyboardWillShowWithWithBeginFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(NSTimeInterval)animationDuration {
    CGRect newKeyboardFrame = [self.keyboardListener convertKeyboardRect:endFrame toView:self.view];
    
    // The lower container is just the same size as the keyboard
    self.lowerContainer.frame = newKeyboardFrame;
    // The upper container covers the rest of our view
    CGFloat upperHeight = self.view.frame.size.height - newKeyboardFrame.size.height;
    CGRect upperFrame = CGRectMake(0, 0, self.view.frame.size.width, upperHeight);
    self.upperContainer.frame = upperFrame;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // The keyboard must be shown before rotation, or we won't get events to be able to recompute our container frames.
    // Static definition of frames does not work well because different languages have different keyboard sizes
    if (![commentTextView isFirstResponder]) {
        [commentTextView becomeFirstResponder];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation)
        || interfaceOrientation == UIInterfaceOrientationPortrait;
}


#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self updateViewWithNewLocation:userLocation.location];
}

@end
