//
//  PostCommentViewController.m
//  appbuildr
//
//  Created by William M. Johnson on 4/5/11.
//  Copyright 2011 pointabout. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PostCommentViewController.h"
#import "UIButton+Socialize.h"
#import "CommentMapView.h"
#import "Socialize.h"
#import "LoadingView.h"
#import "UIKeyboardListener.h"
#import "SocializeLocationManager.h"
#import "UILabel+FormatedText.h"

@interface PostCommentViewController ()

-(void)setShareLocation:(BOOL)enableLocation;
-(void)setUserLocationTextLabel;
-(void)sendButtonPressed:(id)button;
-(void)closeButtonPressed:(id)button;
-(void)configureDoNotShareLocationButton;
-(void)updateViewWithNewLocation: (CLLocation*)userLocation;
-(void) showAllertWithText: (NSString*)allertMsg;

@end 

@implementation PostCommentViewController

@synthesize commentTextView;
@synthesize locationText;
@synthesize doNotShareLocationButton;
@synthesize activateLocationButton;
@synthesize mapOfUserLocation;
@synthesize socialize = _socialize;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
      entityUrlString:(NSString*)entityUrlString 
     keyboardListener:(UIKeyboardListener*)kb 
      locationManager:(SocializeLocationManager*) lManager   
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _socialize = [[Socialize alloc ] initWithDelegate:self];
        _entityUrlString = [entityUrlString retain];
        kbListener = [kb retain];
        locationManager = [lManager retain];
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
    //[_loadingIndicatorView release]; TODO:: check with profile
    [_socialize release];
    [_entityUrlString release];
    [kbListener release];
    [locationManager release];
    [super dealloc];
}

#pragma Location enable/disable button callbacks
-(void) startLoadAnimation
{
    _loadingIndicatorView = [LoadingView loadingViewInView:commentTextView]; //TODO:: probably it should be pushed in separate method
}

-(void) stopLoadAnimation
{
    [_loadingIndicatorView removeView];_loadingIndicatorView = nil;
}

-(void) showAllertWithText: (NSString*)allertMsg
{
    UIAlertView * allert = [[[UIAlertView alloc] initWithTitle:nil 
                                                                        message:allertMsg 
                                                                       delegate:nil 
                                                              cancelButtonTitle:@"OK" 
                                                              otherButtonTitles:nil] autorelease];
    
    [allert show];
}

-(void)updateViewWithNewLocation: (CLLocation*)userLocation
{   
    if (userLocation) {
        
        [mapOfUserLocation setFitLocation: userLocation.coordinate withSpan: [CommentMapView coordinateSpan]];  
        [locationManager findLocationDescriptionWithCoordinate: userLocation.coordinate andWithBlock:^(NSString* userLocationString)
         {
             [self setUserLocationTextLabel];
         }];
    }
}

-(void)setUserLocationTextLabel 
{
    if (locationManager.shouldShareLocation) {
        [self.locationText text: locationManager.currentLocationDescription 
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
    locationManager.shouldShareLocation = enableLocation;
    if (enableLocation) {
        if (![locationManager applicationIsAuthorizedToUseLocationServices])
        {
            [self showAllertWithText:@"Please Turn On Location Services in Settings to Allow This Application to Share Your Location."];
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
    
    [self setUserLocationTextLabel];
}

#pragma mark - Buttons actions

-(IBAction)activateLocationButtonPressed:(id)sender
{
    if (locationManager.shouldShareLocation)
    {
        if (kbListener.isVisible) 
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

#pragma mark - navigation bar button actions
-(void)sendButtonPressed:(id)button {

    [self startLoadAnimation];
    if(locationManager.shouldShareLocation)
    {
        NSNumber* latitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.longitude];        
        [_socialize createCommentForEntityWithKey:_entityUrlString comment:commentTextView.text longitude:longitude latitude:latitude];
    }
    else
        [_socialize createCommentForEntityWithKey:_entityUrlString comment:commentTextView.text longitude:nil latitude:nil];
}

-(void)closeButtonPressed:(id)button {
    [self stopLoadAnimation];
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - SocializeServiceDelegate

-(void)service:(SocializeService *)service didFail:(NSError *)error{

    [self stopLoadAnimation];
    [self showAllertWithText:[error localizedDescription]];
}

-(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object{
    
    [self stopLoadAnimation];
    [self dismissModalViewControllerAnimated:YES];
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

    self.title = @"New Comment";
    
    UIButton * closeButton = [UIButton blackSocializeNavBarButtonWithTitle:@"Cancel"];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
    
    UIButton * sendButton = [UIButton blueSocializeNavBarButtonWithTitle:@"Send"];
    [sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    rightButtonItem.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.commentTextView becomeFirstResponder];    
    [self setShareLocation:locationManager.shouldShareLocation];
    
    [mapOfUserLocation configurate];
    [self configureDoNotShareLocationButton];       
    [self updateViewWithNewLocation: mapOfUserLocation.userLocation.location];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.commentTextView = nil;
    self.locationText = nil;
    self.doNotShareLocationButton = nil;
    self.activateLocationButton = nil;
    self.mapOfUserLocation = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self updateViewWithNewLocation:userLocation.location];
}

@end
