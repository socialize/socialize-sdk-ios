//
//  ComposeCommentViewController.m
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
#import "_SZUserProfileViewController.h"
#import "SocializeAuthenticateService.h"
#import "SocializeGeocoderAdapter.h"
#import "NSString+PlaceMark.h"
#import "SocializeFacebookInterface.h"
#import "SocializePrivateDefinitions.h"
#import "SZHorizontalContainerView.h"
#import "socialize_globals.h"
#import "SZLocationUtils.h"
#import "SDKHelpers.h"
#import "UIDevice+VersionCheck.h"
#import <SZBlocksKit/BlocksKit.h>

#define NO_CITY_MSG @"Could not locate the place name."

#define PORTRAIT_KEYBOARD_HEIGHT 216
#define LANDSCAPE_KEYBOARD_HEIGHT 162

static NSTimeInterval ReverseGeocodeRetryInterval = 10;

@interface SocializeComposeMessageViewController () {
    BOOL _succeededReverseGeocode;
}

@property (nonatomic, retain) NSTimer *reverseGeocodeTimer;

@end

static CommentMapView *sharedMapView;

@implementation SocializeComposeMessageViewController

@synthesize entity = entity_;
@synthesize commentTextView;
@synthesize locationText;
@synthesize doNotShareLocationButton;
@synthesize activateLocationButton;
@synthesize mapOfUserLocation;
@synthesize mapContainer = _mapContainer;
@synthesize delegate = delegate_;
@synthesize lowerContainer = lowerContainer_;
@synthesize upperContainer = upperContainer_;
SYNTH_BLUE_SOCIALIZE_BAR_BUTTON(sendButton, @"Send")
@synthesize messageActionButtonContainer = messageActionButtonContainer_;
@synthesize messageActionButtons = messageActionButtons_;
@synthesize currentLocationDescription = currentLocationDescription_;
@synthesize locationManager = locationManager_;
@synthesize bottomContainerDisabledView;

+ (CommentMapView*)sharedMapView {
    if (sharedMapView == nil) {
        sharedMapView = [[CommentMapView alloc] initWithFrame:CGRectZero];
    }
    
    return sharedMapView;
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        self.entity = entity;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(coreLocationAuthorizationStatusDidChange:)
                                                     name:SocializeCLAuthorizationStatusDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (id)initWithEntityUrlString:(NSString*)entityUrlString {
    SZEntity *entity = [SZEntity entityWithKey:entityUrlString name:nil];
    return [self initWithEntity:entity];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     
    [commentTextView release];
    [doNotShareLocationButton release];
    [activateLocationButton release];
    [mapOfUserLocation release];
    [locationText release];
    [entity_ release];
    [_geoCoderInfo release];
    [_mapContainer release];
    [lowerContainer_ release];
    [upperContainer_ release];
    [sendButton_ release];
    [messageActionButtonContainer_ release];
    [messageActionButtons_ release];
    [currentLocationDescription_ release];
    [locationManager_ release];
    [_currentLocation release];
    [_reverseGeocodeTimer release];
    [_initialText release];
    [_mapViewContainer release];
    
    [bottomContainerDisabledView release];
    [super dealloc];
}

- (SocializeLocationManager*)locationManager {
    if (locationManager_ == nil) {
        locationManager_ = [[SocializeLocationManager sharedLocationManager] retain];
    }
    
    return locationManager_;
}

- (void)cancel {
    [self stopReverseGeocodeTimer];
    [super cancel];
}

- (BOOL)canSend {
    return self.allowEmpty || [commentTextView.text length] > 0;
}

- (void)updateSendButton {
    self.sendButton.enabled = [self canSend];
}

#pragma mark Location enable/disable button callbacks
-(void) startLoadAnimationForView: (UIView*)view {
    [super startLoadAnimationForView:view];
    self.sendButton.enabled = NO;
}

-(void)stopLoadAnimation {
    [super  stopLoadAnimation];
    [self updateSendButton];
}

- (void)attemptReverseGeocode {
    __block id geocoder = [[SocializeGeocoderAdapter alloc]init];
    
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray*placemarks, NSError *error) {
         if(error) {
             self.currentLocationDescription = NO_CITY_MSG;
         }
         else {
             self.currentLocationDescription = [NSString stringWithPlacemark:[placemarks objectAtIndex:0]];
             _succeededReverseGeocode = YES;
             [self stopReverseGeocodeTimer];
         }
         [self configureLocationText];
         [geocoder autorelease];
     }];
}

- (void)stopReverseGeocodeTimer {
    [self.reverseGeocodeTimer invalidate];
    self.reverseGeocodeTimer = nil;
}

- (void)startReverseGeocodeTimer {
    if (_succeededReverseGeocode) {
        return;
    }
    
    if (self.reverseGeocodeTimer != nil) {
        return;
    }
    
    WEAK(self) weakSelf = self;
    self.reverseGeocodeTimer = [NSTimer bk_scheduledTimerWithTimeInterval:ReverseGeocodeRetryInterval
                                                                    block:^(NSTimer *timer) {
                                                                        if (_succeededReverseGeocode) {
                                                                            [weakSelf stopReverseGeocodeTimer];
                                                                        } else {
                                                                            [weakSelf attemptReverseGeocode];
                                                                        }
                                                                    }
                                                                  repeats:YES];
}

- (void)startReverseGeocode {
    [self attemptReverseGeocode];
    [self startReverseGeocodeTimer];
}

-(void)updateViewWithNewLocation: (CLLocation*)userLocation {
    if (userLocation) {
        self.currentLocation = userLocation;
        
        [mapOfUserLocation setFitLocation: userLocation.coordinate withSpan: [CommentMapView coordinateSpan]];
        
        [self startReverseGeocode];
    }
}

-(void)configureLocationText {
    BOOL shareLocation = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey] boolValue];
    if (shareLocation) {
        [self.locationText text:self.currentLocationDescription
                   withFontName:@"Helvetica"
                   withFontSize:12.0
                      withColor:[UIColor colorWithRed:(35.0/255) green:(130.0/255) blue:(210.0/255) alpha:1]
         ];
    }
    else {
        [self.locationText text:@"Location will not be shared."
                   withFontName:@"Helvetica-Oblique"
                   withFontSize:12.0
                      withColor:[UIColor colorWithRed:(167.0/255) green:(167.0/255) blue:(167.0/255) alpha:1]
         ];
    }
}

//Normally a class cluster would be used for this logic, but class hierarchy here makes this simpler
- (void)addSocializeGrayButtonLook:(UIButton*)button {
    if([[UIDevice currentDevice] systemMajorVersion] < 7) {
        UIImage *normalImage = [[UIImage imageNamed:@"socialize-comment-button.png"]stretchableImageWithLeftCapWidth:14 topCapHeight:0] ;
        UIImage *highlightImage = [[UIImage imageNamed:@"socialize-comment-button-active.png"]stretchableImageWithLeftCapWidth:14 topCapHeight:0];
        
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];    
    }
    else {
        UIImage *entityImage = [[UIImage imageNamed:@"socialize-activity-details-btn-link-ios7.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [button setBackgroundImage:entityImage forState:UIControlStateNormal];
    }
}

-(void)configureDoNotShareLocationButton {
    [self addSocializeGrayButtonLook:self.doNotShareLocationButton];
}

-(void)setShareLocation:(BOOL)enableLocation {
    self.shouldShareLocation = enableLocation;

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:enableLocation] forKey:kSocializeShouldShareLocationKey];

    if (enableLocation) {
        [activateLocationButton setImage:[UIImage imageNamed:@"socialize-comment-location-enabled.png"] forState:UIControlStateNormal];
        [activateLocationButton setImage:[UIImage imageNamed:@"socialize-comment-location-enabled.png"] forState:UIControlStateHighlighted];
    }
    else {
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

-(IBAction)activateLocationButtonPressed:(id)sender {
    BOOL shareLocation = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey] boolValue];

    if (shareLocation) {
        if ([commentTextView isFirstResponder]) {
            [commentTextView resignFirstResponder];          
            [self setSubviewForLowerContainer:self.mapContainer];
        }
        else {
            [commentTextView becomeFirstResponder];
        }            
    }
    else {
        if (![SocializeLocationManager locationServicesAvailable]) {
            [self showAlertWithText:@"Please Turn On Location Services in Settings to Allow This Application to Share Your Location." andTitle:nil];
            return;
        }
        
        [self setShareLocation:YES];
        [self setSubviewForLowerContainer:self.mapContainer];
    }
}

-(IBAction)doNotShareLocationButtonPressed:(id)sender {
    [self setShareLocation:NO];
    [commentTextView becomeFirstResponder];
    
    [self disableLowerContainer];
}

#pragma mark - SocializeServiceDelegate

-(void)service:(SocializeService *)service didFail:(NSError *)error {
    if([service isKindOfClass:[SocializeAuthenticateService class]]) {
        [super service:service didFail:error];
    }
    else {
        [self stopLoadAnimation];
        [self failWithError:error];
    }
}

#pragma mark - UITextViewDelegate callbacks

-(void)textViewDidChange:(UITextView *)textView {
    [self updateSendButton];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapOfUserLocation = [[self class] sharedMapView];
    self.mapOfUserLocation.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapOfUserLocation.frame = CGRectMake(0, 0, self.mapViewContainer.frame.size.width, self.mapViewContainer.frame.size.height);
    [self.mapViewContainer addSubview:self.mapOfUserLocation];

    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.navigationItem.rightBarButtonItem = self.sendButton;
    
    if (SZShouldShowNetworkSelection()) {
        [self.sendButton changeTitleOnCustomButtonToText:@"Continue"];
    }
    
    self.commentTextView.text = self.initialText;
    [self.commentTextView becomeFirstResponder];
    
    BOOL shareLocation = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey] boolValue];
    [self setShareLocation:shareLocation];

    [self.mapOfUserLocation roundCorners];
    [self configureDoNotShareLocationButton];       
    [self updateViewWithNewLocation: mapOfUserLocation.userLocation.location];
    
    self.messageActionButtonContainer.rightJustified = YES;
    
    [self updateSendButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([Socialize locationSharingDisabled]) {
        self.mapOfUserLocation.showsUserLocation = NO;
        self.activateLocationButton.hidden = YES;
        self.locationText.hidden = YES;
    }
    else {
        self.mapOfUserLocation.showsUserLocation = YES;
        self.activateLocationButton.hidden = NO;
        self.locationText.hidden = NO;
        [self setSubviewForLowerContainer:self.mapContainer];
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeShouldShareLocationKey] boolValue]) {
            [self disableLowerContainer];
        }
    }
}

- (void)viewDidUnload {
    [self setBottomContainerDisabledView:nil];
    [self setMapViewContainer:nil];
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

- (void)setMessageActionButtons:(NSArray *)messageActionButtons {
    NonatomicRetainedSetToFrom(messageActionButtons_, messageActionButtons);
    self.messageActionButtonContainer.columns = self.messageActionButtons;
    [self.messageActionButtonContainer layoutColumns];
}

- (UIView*)showLoadingInView {
    return self.upperContainer;
}

- (void)disableLowerContainer {
    self.bottomContainerDisabledView.hidden = NO;
    [self.lowerContainer addSubview:self.bottomContainerDisabledView];
}

- (void)enableLowerContainer {
    self.bottomContainerDisabledView.hidden = YES;
}

- (void)keyboardListener:(SocializeKeyboardListener *)keyboardListener keyboardWillShowWithWithBeginFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(NSTimeInterval)animationDuration {
    CGRect newKeyboardFrame = [self.keyboardListener convertKeyboardRect:endFrame toView:self.view];
    
    if (![self isFormsheetModal]) {
        // The lower container is just the same size as the keyboard
        self.lowerContainer.frame = newKeyboardFrame;
        // The upper container covers the rest of our view
        CGFloat upperHeight = self.view.frame.size.height - newKeyboardFrame.size.height;
        CGRect upperFrame = CGRectMake(0, 0, self.view.frame.size.width, upperHeight);
        self.upperContainer.frame = upperFrame;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
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
    [[SocializeLocationManager sharedLocationManager] tryToAcceptLocation:[userLocation location]];
    [self updateViewWithNewLocation:userLocation.location];
}

- (void)coreLocationAuthorizationStatusDidChange:(NSNotification*)notification {
    CLAuthorizationStatus status = kCLAuthorizationStatusNotDetermined;
    [[[notification userInfo] objectForKey:kSocializeCLAuthorizationStatusKey] getValue:&status];
    
    if (status == kCLAuthorizationStatusAuthorized) {
        [self setShareLocation:YES];
    } else {
        [self setShareLocation:NO];
    }
}

- (void)sendButtonPressed:(UIButton*)sendButton {
    [self notifyDelegateOfCompletion];
}

@end
