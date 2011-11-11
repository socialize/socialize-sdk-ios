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
#import "LoadingView.h"
#import "UIKeyboardListener.h"
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
-(void)setUserLocation; 
-(void)configureDoNotShareLocationButton;
-(void)updateViewWithNewLocation: (CLLocation*)userLocation;
-(void) adjustViewToLayoutWithKeyboardHeigth:(int)keyboardHeigth;


@end 

@implementation SocializeComposeMessageViewController

@synthesize commentTextView;
@synthesize locationText;
@synthesize doNotShareLocationButton;
@synthesize activateLocationButton;
@synthesize mapOfUserLocation;
@synthesize locationViewContainer = _locationViewContainer;
@synthesize mapContainer = _mapContainer;
@synthesize locationManager = _locationManager;
@synthesize kbListener = _kbListener;
@synthesize entityURL = _entityURL;
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
    [_kbListener release];
    [_locationManager release];
    [_geoCoderInfo release];
    [_locationViewContainer release];
    [_mapContainer release];

    [super dealloc];
}

- (UIKeyboardListener*)kbListener {
    if (_kbListener == nil) {
        _kbListener = [[UIKeyboardListener createWithVisibleKeyboard:NO] retain];
    }
    
    return _kbListener;
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
                 NSLog(@"reverseGeocoder didFailWithError:%@", error);
                 self.locationManager.currentLocationDescription = NO_CITY_MSG;
             }
             else
             {
                 self.locationManager.currentLocationDescription = [NSString stringWithPlacemark:[placemarks objectAtIndex:0]];
             }
             [self setUserLocation];
             [geocoder autorelease];
         }
         ];
    }
}

-(void)setUserLocation
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

-(void)configureDoNotShareLocationButton
{   
    UIImage * normalImage = [[UIImage imageNamed:@"socialize-comment-button.png"]stretchableImageWithLeftCapWidth:14 topCapHeight:0] ;
    UIImage * highlightImage = [[UIImage imageNamed:@"socialize-comment-button-active.png"]stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    [self.doNotShareLocationButton setBackgroundImage:normalImage forState:UIControlStateNormal];
	[self.doNotShareLocationButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
}

-(void)setShareLocation:(BOOL)enableLocation 
{   
    self.locationManager.shouldShareLocation = enableLocation;
    if (enableLocation) {
        if (![self.locationManager applicationIsAuthorizedToUseLocationServices])
        {
            [self showAllertWithText:@"Please Turn On Location Services in Settings to Allow This Application to Share Your Location." andTitle:nil];
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
    
    [self setUserLocation];
}

#pragma mark - Buttons actions

-(IBAction)activateLocationButtonPressed:(id)sender
{
    if (self.locationManager.shouldShareLocation)
    {
        if (self.kbListener.isVisible) 
        {
            [commentTextView resignFirstResponder];          
        }
        else
        {
            [commentTextView becomeFirstResponder];
        }            
    }
    else
    {
        [self setShareLocation:YES];
    }
}

-(IBAction)doNotShareLocationButtonPressed:(id)sender
{  
    [self setShareLocation:NO];
    [commentTextView becomeFirstResponder];
}

-(void)cancelButtonPressed:(UIButton*)button {
    [self stopLoadAnimation];
    [self dismissModalViewControllerAnimated:YES];
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
        [self showAllertWithText:[error localizedDescription] andTitle:@"Post comment"];  
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Ensure kb listener initialized the first time the view appears
    (void)self.kbListener;
    
    [self.commentTextView becomeFirstResponder];    
    [self setShareLocation:self.locationManager.shouldShareLocation];
    
    [mapOfUserLocation configurate];
    [self configureDoNotShareLocationButton];       
    [self updateViewWithNewLocation: mapOfUserLocation.userLocation.location];
    
    if(UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
        [self adjustViewToLayoutWithKeyboardHeigth:PORTRAIT_KEYBOARD_HEIGHT];
    else
        [self adjustViewToLayoutWithKeyboardHeigth:LANDSCAPE_KEYBOARD_HEIGHT];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
        
    self.commentTextView = nil;
    self.locationText = nil;
    self.doNotShareLocationButton = nil;
    self.activateLocationButton = nil;
    self.mapOfUserLocation = nil;
    self.locationViewContainer = nil;
    self.mapContainer = nil;
}

- (UIView*)showLoadingInView {
    return commentTextView;
}

-(void) adjustViewToLayoutWithKeyboardHeigth:(int)keyboardHeigth
{
    CGRect commentFrame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - self.locationViewContainer.frame.size.height - keyboardHeigth);
    self.commentTextView.frame = commentFrame;
    
    CGRect activateLoactionButtonFrame = self.locationViewContainer.frame;
    activateLoactionButtonFrame.origin.y = self.commentTextView.frame.origin.y + self.commentTextView.frame.size.height;
    self.locationViewContainer.frame = activateLoactionButtonFrame;
    
    CGRect mapContainerFrame = CGRectMake(0,self.view.frame.size.height - keyboardHeigth, self.view.frame.size.width, keyboardHeigth);
    
    self.mapContainer.frame = mapContainerFrame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {       
        [self adjustViewToLayoutWithKeyboardHeigth: LANDSCAPE_KEYBOARD_HEIGHT];
    }
    else
    {
        [self adjustViewToLayoutWithKeyboardHeigth: PORTRAIT_KEYBOARD_HEIGHT];
    }
    
    
    return YES;
}


#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self updateViewWithNewLocation:userLocation.location];
}

@end
