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
#import "SocializeProfileViewController.h"

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define NO_LOCATION_MSG @"No location associated with this comment."
#define NO_CITY_MSG @"Could not locate the place name."
#define NO_COMMENT_MSG @"Could not load comment."

#define kCenterPointLatitude  37.779941
#define kCenterPointLongitude -122.417908


@interface SocializeActivityDetailsViewController()<SocializeProfileViewControllerDelegate>
-(void) showComment;
-(void) setupCommentGeoLocation;
-(void) showShareLocation:(BOOL)hasLocation;
-(SocializeProfileViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
@end

@implementation SocializeActivityDetailsViewController

@synthesize activityDetailsView;
@synthesize socializeActivity = socializeActivity_;
@synthesize profileImageDownloader;
@synthesize activityViewController = activityViewController_;
@synthesize activityDisplayText = activityDisplayText_;
@synthesize cache;


#pragma mark init/dealloc
- (void)dealloc
{
    self.socializeActivity = nil;
    self.activityDisplayText = nil;
    [activityDetailsView release]; activityDetailsView = nil;

    [cache release];
    [super dealloc];
}
-(id)initWithActivity:(id<SocializeActivity>)socializeActivity {
    //super will automatically init with the right viewcontroller
    if(self=[super initWithNibName:nil bundle:nil]) {
        //this property has a custom setter method below
        self.socializeActivity = socializeActivity;
    }
    return self;
}

#pragma mark user location
-(void)setSocializeActivity:(id<SocializeActivity>)socializeActivity {
    if(socializeActivity_) {
        [socializeActivity_ release];
        socializeActivity_ = nil;
    }
    socializeActivity_ = [socializeActivity retain];
    if( socializeActivity_ ) {
        //set the display text based on the socialize activity
        if ([self.socializeActivity isKindOfClass:[SocializeComment class]]) {
            self.activityDisplayText = ((SocializeComment *)self.socializeActivity).text;
            self.activityViewController.currentUser = self.socializeActivity.user.objectID;

        } 
    }
}
#pragma mark - geo/location setup and show
-(void)setupCommentGeoLocation
{
    CLLocation* location = [[[CLLocation alloc]initWithLatitude:[self.socializeActivity.lat doubleValue] longitude:[self.socializeActivity.lng doubleValue]]autorelease];
    
    [activityDetailsView updateGeoLocation: location.coordinate];
    
    __block SocializeGeocoderAdapter* adapter = [[SocializeGeocoderAdapter alloc] init];
    [adapter reverseGeocodeLocation:location completionHandler:^(NSArray*placemarks, NSError *error)
     {
         if(error)
         {
             [activityDetailsView updateLocationText: NO_CITY_MSG];
         }
         else
         {
             [activityDetailsView updateLocationText:[NSString stringWithPlacemark:[placemarks objectAtIndex:0]]];
         }    
         [adapter autorelease];
     }
    ];
}
-(void)showShareLocation:(BOOL)hasLocation
{
    activityDetailsView.showMap = hasLocation;
    if (hasLocation) 
    {
        [self setupCommentGeoLocation];
        [activityDetailsView updateNavigationImage:[UIImage imageNamed:@"socialize-comment-details-icon-geo-enabled.png"]];
    }
    else
    {
        [activityDetailsView updateLocationText: NO_LOCATION_MSG 
                                         color: [UIColor colorWithRed:127/ 255.f green:139/ 255.f blue:147/ 255.f alpha:1.0] 
                                          fontName:@"Helvetica-Oblique" 
                                          fontSize:12];
        [activityDetailsView updateNavigationImage:[UIImage imageNamed:@"socialize-comment-details-icon-geo-disabled.png"]]; 
    }  
}


-(void) showComment
{   
    HtmlPageCreator* htmlCreator = [[HtmlPageCreator alloc]init];

    if([htmlCreator loadTemplate:[[NSBundle mainBundle] pathForResource:@"comment_template_clear" ofType:@"htm"]])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy 'at' h:mm a"];      
        [htmlCreator addInformation:[dateFormatter stringFromDate:self.socializeActivity.date] forTag:@"DATE_TEXT"];
        [dateFormatter release]; dateFormatter = nil;
        
        if(self.activityDisplayText)
        {        
            NSMutableString* commentText = [[[NSMutableString alloc] initWithString:self.activityDisplayText] autorelease];       
            [commentText replaceOccurrencesOfString: @"\n" withString:@"<br>" options:NSLiteralSearch range:NSMakeRange(0, [commentText length])];
            [htmlCreator addInformation:commentText forTag: @"COMMENT_TEXT"];
        }
        else
        {
            [htmlCreator addInformation:NO_COMMENT_MSG 
                                 forTag: @"COMMENT_TEXT"];    
        }
        
        [activityDetailsView updateCommentMsg:htmlCreator.html];
    }
    else
    {
        // Could not create dynamic html for comment
        [activityDetailsView updateCommentMsg:self.activityDisplayText];
    }
    
    [htmlCreator release];
}

#pragma mark - profile view methods
-(IBAction)profileButtonTapped:(id)sender {
    SocializeProfileViewController *profileViewController = [self getProfileViewControllerForUser:self.socializeActivity.user];
    profileViewController.navigationItem.leftBarButtonItem = [self createLeftNavigationButtonWithCaption:@"Comment"];
    [self.navigationController pushViewController:(UIViewController *)profileViewController animated:YES];
}

-(SocializeProfileViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user {
    SocializeProfileViewController *profileViewController = [[[SocializeProfileViewController alloc]initWithUser:user delegate:self] autorelease];
    return profileViewController;
}

- (void)profileViewControllerDidCancel:(SocializeProfileViewController*)profileViewController {
    //implement
}
- (void)profileViewControllerDidSave:(SocializeProfileViewController*)profileViewController {
        //implement
}

-(void)updateProfileImage
{
    if(self.socializeActivity.user.smallImageUrl != nil && [self.socializeActivity.user.smallImageUrl length]>0)
    {
        UIImage* image = [cache imageFromCache:self.socializeActivity.user.smallImageUrl];
        if(image)
        {
            [activityDetailsView updateProfileImage: image];
        }
        else
        {
            CompleteBlock complete = [[^(ImagesCache* imgs){
                [activityDetailsView updateProfileImage: [imgs imageFromCache:self.socializeActivity.user.smallImageUrl]];
            }copy] autorelease];
            
            [cache loadImageFromUrl:self.socializeActivity.user.smallImageUrl withLoader:[UrlImageLoader class] andCompleteAction:complete];
        }
    }
}

#pragma mark - activityviewcontroller methods
- (void)addActivityControllerToView {
    CGRect activityFrame = self.view.frame;
	self.activityViewController.view.frame = CGRectMake(0,245, activityFrame.size.width, activityFrame.size.height-160);
    [self.view addSubview:self.activityViewController.view];

}

- (SocializeActivityViewController*)activityViewController {
    if (activityViewController_ == nil) {
        activityViewController_ = [[SocializeActivityViewController alloc] init];
        activityViewController_.delegate = self;
        activityViewController_.dontShowNames = YES;
        activityViewController_.dontShowDisclosure = NO;
    }
    return activityViewController_;
}


#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{ 
    [super viewWillAppear:animated];
    [self updateProfileImage];
    [self.activityDetailsView updateUserName:self.socializeActivity.user.userName];
    [self showComment];
    [self.activityDetailsView configurateView];
}

-(void)viewWillDisappear:(BOOL)animated
{   
    [super viewWillDisappear:animated];
    [cache stopOperations];
    
    [self.profileImageDownloader cancelDownload];
    self.profileImageDownloader = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showShareLocation:self.socializeActivity.lat != nil];
    [self addActivityControllerToView];
    [self.activityViewController initializeContent];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
