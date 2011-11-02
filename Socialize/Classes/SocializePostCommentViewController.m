//
//  PostCommentViewController.m
//  appbuildr
//
//  Created by William M. Johnson on 4/5/11.
//  Copyright 2011 pointabout. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SocializePostCommentViewController.h"
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

#define NO_CITY_MSG @"Could not locate the place name."
#define MIN_DISMISS_INTERVAL 0.75

#define PORTRAIT_KEYBOARD_HEIGHT 216
#define LANDSCAPE_KEYBOARD_HEIGHT 162

@interface SocializePostCommentViewController ()

-(void)setShareLocation:(BOOL)enableLocation;
-(void)setUserLocation; 
-(void)sendButtonPressed:(id)button;
-(void)closeButtonPressed:(id)button;
-(void)configureDoNotShareLocationButton;
-(void)updateViewWithNewLocation: (CLLocation*)userLocation;
-(void)createComment;
-(void)authenticateViaFacebook;
-(void) adjustViewToLayoutWithKeyboardHeigth:(int)keyboardHeigth;


@end 

@implementation SocializePostCommentViewController

@synthesize commentTextView;
@synthesize locationText;
@synthesize doNotShareLocationButton;
@synthesize activateLocationButton;
@synthesize mapOfUserLocation;
@synthesize facebookAuthQuestionDialog = _facebookAuthQuestionDialog;
@synthesize locationViewContainer = _locationViewContainer;
@synthesize mapContainer = _mapContainer;

+(UINavigationController*)createNavigationControllerWithPostViewControllerOnRootWithEntityUrl:(NSString*)url andImageForNavBar: (UIImage*)imageForBar
{
    SocializePostCommentViewController * pcViewController = [[SocializePostCommentViewController alloc] initWithNibName:@"SocializePostCommentViewController" 
                                                                                               bundle:nil 
                                                                                      entityUrlString:url
                                                                                     keyboardListener:[UIKeyboardListener createWithVisibleKeyboard:NO] 
                                                                                      locationManager:[SocializeLocationManager create]
                                                                                         geocoderInfo:[SocializeGeocoderAdapter class]
                                                    
                                                    ];
    
    UIImage * socializeNavBarBackground = imageForBar;
    UINavigationController * pcNavController = [[[UINavigationController alloc] initWithRootViewController:pcViewController] autorelease];
    [pcNavController.navigationBar setBackgroundImage:socializeNavBarBackground];
    [pcViewController release];

    return pcNavController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
      entityUrlString:(NSString*)entityUrlString 
     keyboardListener:(UIKeyboardListener*)kb 
      locationManager:(SocializeLocationManager*) lManager
         geocoderInfo:(Class)geocoderInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _entityUrlString = [entityUrlString retain];
        kbListener = [kb retain];
        locationManager = [lManager retain];
        _geoCoderInfo = geocoderInfo;
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
    [_entityUrlString release];
    [kbListener release];
    [locationManager release];
    [_facebookAuthQuestionDialog release];
    [_geoCoderInfo release];
    [_locationViewContainer release];
    [_mapContainer release];

    [super dealloc];
}

- (UIAlertView*)facebookAuthQuestionDialog {
    if (_facebookAuthQuestionDialog == nil) 
    {
        _facebookAuthQuestionDialog = [[UIAlertView alloc]
                                       initWithTitle:@"Facebook?" message:@"You are not authenticated with Facebook. Authenticate with Facebook now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    }
    
    return _facebookAuthQuestionDialog;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.facebookAuthQuestionDialog) 
    {   
        if (buttonIndex == 1)
        {
            [self.socialize authenticateWithFacebook];
        } else
        {
            [self createComment];
        }
    } 
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
        
        __block id geocoder = [[_geoCoderInfo alloc]init];
        
        [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray*placemarks, NSError *error)
         {
             if(error)
             {
                 NSLog(@"reverseGeocoder didFailWithError:%@", error);
                 locationManager.currentLocationDescription = NO_CITY_MSG;
             }
             else
             {
                 locationManager.currentLocationDescription = [NSString stringWithPlacemark:[placemarks objectAtIndex:0]];
             }
             [self setUserLocation];
             [geocoder autorelease];
         }
         ];
    }
}

-(void)setUserLocation
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

- (void)createComment {
    if(locationManager.shouldShareLocation)
    {
        NSNumber* latitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.longitude];        
        [self.socialize createCommentForEntityWithKey:_entityUrlString comment:commentTextView.text longitude:longitude latitude:latitude];
    }
    else
        [self.socialize createCommentForEntityWithKey:_entityUrlString comment:commentTextView.text longitude:nil latitude:nil];
}

- (void)authenticateViaFacebook {
    [self.facebookAuthQuestionDialog show];
}

#pragma mark - navigation bar button actions
-(void)sendButtonPressed:(id)button {
    [self startLoadAnimationForView:commentTextView];
    
    if (![self.socialize isAuthenticatedWithFacebook] && [Socialize facebookAppId] != nil) {
        [self authenticateViaFacebook];
    } else {
        [self createComment];
    }
}

-(void)closeButtonPressed:(id)button {
    [self stopLoadAnimation];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SocializeServiceDelegate

-(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object{   
    // Rapid animated dismissal does not work on iOS5 (but works in iOS4)
    // Allow previous modal dismisalls to complete. iOS5 added dismissViewControllerAnimated:completion:, which
    // we would use here if backward compatibility was not required.   
    if([self.socialize isAuthenticatedWithFacebook])
    {
        SocializeShareBuilder* shareBuilder = [[SocializeShareBuilder new] autorelease];
        shareBuilder.shareProtocol = [[SocializeFacebookInterface new] autorelease];
        shareBuilder.shareObject = (id<SocializeActivity>)object;
        [shareBuilder performShareForPath:@"me/feed"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, MIN_DISMISS_INTERVAL * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopLoadAnimation];
        [self dismissModalViewControllerAnimated:YES];
    });
}

- (void)showProfile {
    SocializeProfileViewController *profile = [[[SocializeProfileViewController alloc] init] autorelease];
    profile.delegate = self;
    
    UINavigationController *navigationController = [[[UINavigationController alloc]
                                                     initWithRootViewController:profile]
                                                    autorelease];
    
    [self presentModalViewController:navigationController animated:YES];
}

- (void)profileViewControllerDidSave:(SocializeProfileViewController *)profileViewController {
    [self dismissModalViewControllerAnimated:YES];
    [self startLoadAnimationForView:commentTextView];
    [self createComment];
}

- (void)profileViewControllerDidCancel:(SocializeProfileViewController *)profileViewController {
    [self dismissModalViewControllerAnimated:YES];
    [self startLoadAnimationForView:commentTextView];
    [self createComment];
}

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

-(void)didAuthenticate:(id<SocializeUser>)user {
    if (![SocializeAuthenticateService isAuthenticatedWithFacebook]) {
        [super didAuthenticate:user];//complete anonymous authentication
    } else {
        [self stopLoadAnimation];
        [self showProfile];
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
    self.facebookAuthQuestionDialog = nil;
    self.locationViewContainer = nil;
    self.mapContainer = nil;
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
