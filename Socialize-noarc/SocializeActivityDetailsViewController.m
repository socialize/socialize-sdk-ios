//
//  CommentDetailsViewController.m
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeActivityDetailsViewController.h"
#import "SocializeComment.h"
#import "CommentDetailsView.h"
#import "CommentMapView.h"
#import "UIButton+Socialize.h"
#import "UILabel-Additions.h"
#import "HtmlPageCreator.h"
#import "URLDownload.h"
#import "NSString+PlaceMark.h"
#import "ImagesCache.h"
#import "ImageLoader.h"
#import "SocializeGeocoderAdapter.h"
#import "_SZUserProfileViewController.h"
#import "socialize_globals.h"
#import <QuartzCore/QuartzCore.h>
#import "SZUserUtils.h"
#import <SZBlocksKit/BlocksKit+UIKit.h>

#define kCenterPointLatitude  37.779941
#define kCenterPointLongitude -122.417908


@interface SocializeActivityDetailsViewController()
@end

@implementation SocializeActivityDetailsViewController

@synthesize activityDetailsView = activityDetailsView_;
@synthesize socializeActivity = socializeActivity_;
@synthesize activityViewController = activityViewController_;
@synthesize delegate = delegate_;
@synthesize currentLocationDescription = _currentLocationDescription;

#pragma mark init/dealloc
- (void)dealloc
{
    self.socializeActivity = nil;
    self.activityDetailsView = nil;
    self.activityViewController = nil;
    [super dealloc];
}

-(id)init {
    if(self=[self initWithActivity:nil]) {
        //any additional 
    }
    return self;
}

-(id)initWithActivity:(id<SocializeActivity>)socializeActivity {
    //super will automatically init with the right viewcontroller
    if(self=[super initWithNibName:nil bundle:nil]) {
        //using ivar because it's a readonly property
        [self setSocializeActivity:socializeActivity];
    }
    return self;
}

- (BOOL)isCurrentUserProfile {
    return (self.socializeActivity.user.objectID == [[self.socialize authenticatedUser] objectID]);
}

- (void)configureSettingsButton {
    if ([self isCurrentUserProfile]) {
        self.navigationItem.rightBarButtonItem = self.settingsButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark fetching/setting socialize activity
-(void)fetchActivityForType:(NSString*)activityType activityID:(NSNumber*)activityID {
    //comments are currently the only type that exist
    [self.socialize getCommentById:[activityID intValue]];    
}

- (IBAction)locationButtonPressed:(id)sender {
    CLLocation *location = [self activityLocation];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"Open in maps?" message:@"External application required"];
    [alertView bk_addButtonWithTitle:@"No" handler:nil];
    [alertView bk_addButtonWithTitle:@"Yes" handler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f", coordinate.latitude, coordinate.longitude]]];
    }];
    [alertView show];
}

- (void)configureInterfaceForLocation {
    if ([self.currentLocationDescription length] > 0) {
        self.activityDetailsView.locationTextLabel.text = self.currentLocationDescription;
        self.activityDetailsView.locationPinButton.enabled = YES;
        self.activityDetailsView.locationFatButton.enabled = YES;
    } else {
        self.activityDetailsView.locationTextLabel.text = @"Location unavailable";
        self.activityDetailsView.locationPinButton.enabled = NO;            
        self.activityDetailsView.locationFatButton.enabled = NO;
    }
}

- (CLLocation*)activityLocation {
    NSNumber *lat = self.socializeActivity.lat;
    NSNumber *lng = self.socializeActivity.lng;
    if (lat != nil && lng != nil) {
        CLLocation *location = [[[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]] autorelease];
        return location;
    }
    return nil;
}

- (void)reverseGeocodeLocationAndUpdateInterface {
    
    CLLocation *location = [self activityLocation];
    
    if (location != nil) {
        __block id geocoder = [[SocializeGeocoderAdapter alloc] init];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray*placemarks, NSError *error)
         {
             if (error != nil) {
                 self.currentLocationDescription = nil;
             }
             else {
                 self.currentLocationDescription = [NSString stringWithPlacemark:[placemarks objectAtIndex:0]];
             }
             
             [self configureInterfaceForLocation];
             [geocoder autorelease];
         }
         ];
    }
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray {
    if ([dataArray count]){
        id<SocializeObject> object = [dataArray objectAtIndex:0];
        if ([object conformsToProtocol:@protocol(SocializeActivity)]){
            //  do entity saving here. 
            //  All the entity related information can be fetched here ie stats or name.
            self.socializeActivity = (id<SocializeActivity>)object;
            [self loadActivityDetailData];
            [self configureSettingsButton];
            
            if ([self.delegate respondsToSelector:@selector(activityDetailsViewController:didLoadActivity:)]) {
                [self.delegate activityDetailsViewController:self didLoadActivity:self.socializeActivity];
            }
        }
    }
}

-(void)loadActivityDetailData {
    if(self.socializeActivity) {
        [self.activityViewController initializeContent];
        self.activityDetailsView.activity = self.socializeActivity;

        [self updateProfileImage];
        //once all the data is being loaded or fetched we can turn off the animation
        [self stopLoadAnimation];
        
        NSString *showEntityTitle = self.socializeActivity.entity.name;
        if ([showEntityTitle length] == 0) {
            showEntityTitle = @"Show More";
        }
        [self.activityDetailsView.showEntityButton setTitle:showEntityTitle forState:UIControlStateNormal];
    }
}

-(void)configureDetailsView {
    self.activityViewController.currentUser = self.socializeActivity.user.objectID;
    self.activityDetailsView.username = self.socializeActivity.user.displayName;
}

-(void)setSocializeActivity:(id<SocializeActivity>)socializeActivity {
    NonatomicRetainedSetToFrom(socializeActivity_, socializeActivity);
    if( socializeActivity_ ) {
        //when the socialize activity changes we should also let the recent activity view controller
        //know that there is a new user for which to load recent activity.
        [self configureDetailsView];
    }
}

-(void)updateProfileImage
{
    [self loadImageAtURL:self.socializeActivity.user.smallImageUrl
            startLoading:^{}
             stopLoading:^{}
              completion:^(UIImage *image) {
                  [self.activityDetailsView updateProfileImage: image];
            }];
}   

- (void)configureActivityViewController {
    self.activityViewController.dontShowNames = YES;
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{ 
    [super viewWillAppear:animated];
    [self loadActivityDetailData];
    
    [self configureInterfaceForLocation];
    [self reverseGeocodeLocationAndUpdateInterface];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //iOS 7 adjustments for nav bar and cell separator
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self configureDetailsView];
    [self startLoadAnimationForView:self.activityDetailsView];   
    self.activityViewController.tableView.tableHeaderView = self.activityDetailsView;
    [self.view addSubview:self.activityViewController.view];

    [self configureSettingsButton];

    [self configureActivityViewController];
}

- (void)activityDetailsViewDidFinishLoad:(SocializeActivityDetailsView *)activityDetailsView {
    // This needs to be reset if its size changes
    self.activityViewController.tableView.tableHeaderView = self.activityDetailsView;
}

- (IBAction)showEntityButtonPressed:(id)sender {
    SocializeEntityLoaderBlock entityLoader = [Socialize entityLoaderBlock];
    if (entityLoader != nil) {
        entityLoader(self.navigationController, self.socializeActivity.entity);
    }
}

- (IBAction)profileButtonPressed:(id)sender {
    [SZUserUtils showUserProfileInViewController:self user:self.socializeActivity.user completion:nil];    
}

- (void)activityViewController:(SocializeActivityViewController*)activityViewController profileTappedForUser:(id<SocializeUser>)user {
    [SZUserUtils showUserProfileInViewController:self user:user completion:nil];
}

- (void)activityViewController:(SocializeActivityViewController *)activityViewController activityTapped:(id<SocializeActivity>)activity {
    SocializeEntityLoaderBlock entityLoader = [Socialize entityLoaderBlock];
    if (self.navigationController != nil && entityLoader != nil) {
        entityLoader(self.navigationController, activity.entity);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
}

@end
