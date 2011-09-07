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
#import "AppMakrLocation.h"
#import "Socialize.h"
#import "LoadingView.h"
#import "NSString+PlaceMark.h"

@interface PostCommentViewController ()

-(void)setShareLocation:(BOOL)enableLocation;
-(void)setUserLocationTextLabel;
-(void)sendButtonPressed:(id)button;
-(void)closeButtonPressed:(id)button;
-(void)configureDoNotShareLocationButton;

@property(nonatomic, retain) NSString * userLocationText;

@end 

@implementation PostCommentViewController

@synthesize commentTextView;
@synthesize locationText;
@synthesize userLocationText;
@synthesize doNotShareLocationButton;
@synthesize activateLocationButton;
@synthesize mapOfUserLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityUrlString:(NSString*)entityUrlString
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _socialize = [[Socialize alloc ] initWithDelegate:self]; //TODO:: send as a parametr
        _entityUrlString = [entityUrlString retain];
    }
    return self;
}

- (void)dealloc
{
    [commentTextView release];
    [doNotShareLocationButton release];
    [activateLocationButton release];
    [mapOfUserLocation release];
    [userLocationText release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma Location enable/disable button callbacks
-(void)setUserLocationTextLabel
{
    //TODO:: send text as a parametr 
    if (shareLocation) {
        
        self.locationText.text = self.userLocationText;
        self.locationText.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        self.locationText.textColor = [UIColor colorWithRed:(35.0/255) green:(130.0/255) blue:(210.0/255) alpha:1];
        
    }
    else {

        self.locationText.text = @"Location will not be shared.";
        self.locationText.font = [UIFont fontWithName:@"Helvetica-Oblique" size:12.0];
        self.locationText.textColor = [UIColor colorWithRed:(167.0/255) green:(167.0/255) blue:(167.0/255) alpha:1];

    }
}

-(void)setShareLocation:(BOOL)enableLocation {
    
    if (enableLocation) {
        
        //TODO:: move this in separate method due to unit testing.
        if (![AppMakrLocation applicationIsAuthorizedToUseLocationServices])
        {
            UIAlertView * locationNotEnabledAlert = [[[UIAlertView alloc] initWithTitle:nil 
                                                      message:@"Please Turn On Location Services in Settings to Allow This Application to Share Your Location." 
                                                                             delegate:nil 
                                                                    cancelButtonTitle:@"OK" 
                                                                    otherButtonTitles:nil] autorelease];
            
            [locationNotEnabledAlert show];
            
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
    
    shareLocation = enableLocation;
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:shareLocation] forKey:@"post_comment_share_location"];
    [self setUserLocationTextLabel];
}

-(IBAction)activateLocationButtonPressed:(id)sender
{
    if (shareLocation)
    {
        if (keyboardIsVisible) 
        {
            
            [commentTextView resignFirstResponder];
            keyboardIsVisible = FALSE;
          
        }
        else
        {
            [commentTextView becomeFirstResponder];
            keyboardIsVisible = YES;
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
    keyboardIsVisible = YES;
}

#pragma mark - navigation bar button actions
-(void)sendButtonPressed:(id)button {

    NSNumber* latitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.longitude];
    
    _loadingIndicatorView = [LoadingView loadingViewInView:commentTextView]; //TODO:: probably it should be pushed in separate method
    [_socialize createCommentForEntityWithKey:_entityUrlString comment:commentTextView.text longitude:longitude latitude:latitude];
}

#pragma mark SocializeServiceDelegate

-(void)service:(SocializeService *)service didFail:(NSError *)error{

    [_loadingIndicatorView removeView]; _loadingIndicatorView = nil;
    //TODO:: decide what to do with allert.
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
    
}

-(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object{
    
    [_loadingIndicatorView removeView];_loadingIndicatorView = nil;
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark -
-(void)closeButtonPressed:(id)button {
    [_loadingIndicatorView removeView];_loadingIndicatorView = nil;
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
    keyboardIsVisible = YES;
    
    if ([AppMakrLocation applicationIsAuthorizedToUseLocationServices])
    {
        NSNumber * shareLocationBoolean = (NSNumber *)[[NSUserDefaults standardUserDefaults]valueForKey:@"post_comment_share_location"];
        [self setShareLocation: (shareLocationBoolean !=nil)?[shareLocationBoolean boolValue]:YES];
    }
    else
    {
        [self setShareLocation:NO];
    }
    
    //TODO:: We should change the following implementation "Do not Share"
    CGRect frame = self.doNotShareLocationButton.frame;
    [self.doNotShareLocationButton configureWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];  
    self.doNotShareLocationButton.frame = frame;
    [self configureDoNotShareLocationButton];
    
    [mapOfUserLocation configurate];
    
    MKUserLocation * userLocation = mapOfUserLocation.userLocation;
    CLLocation * newLocation = userLocation.location;
    
    if (newLocation) {
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.0025;
        span.longitudeDelta = 0.0025; //TODO:: Reomove thise one. Instead use Map class method
        
        [mapOfUserLocation setFitLocation:newLocation.coordinate withSpan: span];
       
        // this creates a MKReverseGeocoder to find a placemark using the found coordinates
        MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
        geoCoder.delegate = self;
        [geoCoder start];
    }
}

-(void)configureDoNotShareLocationButton
{
    NSString * normalImageURI = nil;
    NSString * highlightImageURI = nil;
    
    normalImageURI = @"socialize-comment-button.png";
    highlightImageURI = @"socialize-comment-button-active.png";
    
    UIImage * normalImage = [[UIImage imageNamed:normalImageURI]stretchableImageWithLeftCapWidth:14 topCapHeight:0] ;
	
    UIImage * highlightImage = [[UIImage imageNamed:highlightImageURI]stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    [self.doNotShareLocationButton setBackgroundImage:normalImage forState:UIControlStateNormal];
	[self.doNotShareLocationButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocation * newLocation = userLocation.location;
    if (newLocation) 
    {
        MKCoordinateSpan span;
        span.latitudeDelta = 0.0025;
        span.longitudeDelta = 0.0025;
        
        [mapOfUserLocation setFitLocation:newLocation.coordinate withSpan: span];
    
        // this creates a MKReverseGeocoder to find a placemark using the found coordinates
        MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
        geoCoder.delegate = self;
        [geoCoder start];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    self.userLocationText = [NSString stringWithPlacemark:placemark];
    
    [self setUserLocationTextLabel];
  
    geocoder.delegate = nil;
    [geocoder autorelease];
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
    geocoder.delegate = nil;
    [geocoder autorelease];
}

@end
