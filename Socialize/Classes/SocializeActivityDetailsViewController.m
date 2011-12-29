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



#define kCenterPointLatitude  37.779941
#define kCenterPointLongitude -122.417908


@interface SocializeActivityDetailsViewController()<SocializeProfileViewControllerDelegate>
-(SocializeProfileViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
@end

@implementation SocializeActivityDetailsViewController

@synthesize activityDetailsView = activityDetailsView_;
@synthesize socializeActivity = socializeActivity_;
@synthesize profileImageDownloader = profileImageDownloader_;
@synthesize activityViewController = activityViewController_;
@synthesize cache = cache_;


#pragma mark init/dealloc
- (void)dealloc
{
    self.activityDetailsView = nil;
    self.socializeActivity = nil;
    self.profileImageDownloader = nil;
    self.activityViewController = nil;
    self.cache = nil;
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

#pragma mark setting socialize activity
-(void)setSocializeActivity:(id<SocializeActivity>)socializeActivity {
    NSAssert([socializeActivity isKindOfClass:[SocializeComment class]], @"socialize activity details only  currently handles of type socialize comment");
    if(socializeActivity_) {
        [socializeActivity_ release];
        socializeActivity_ = nil;
    }
    if( socializeActivity) {
        socializeActivity_ = [socializeActivity retain];
        self.activityViewController.currentUser = socializeActivity_.user.objectID;
    }
}


-(void)updateProfileImage
{
    if(self.socializeActivity.user.smallImageUrl != nil && [self.socializeActivity.user.smallImageUrl length]>0)
    {
        UIImage* image = [self.cache imageFromCache:self.socializeActivity.user.smallImageUrl];
        if(image)
        {
            [self.activityDetailsView updateProfileImage: image];
        }
        else
        {
            CompleteBlock complete = [[^(ImagesCache* imgs){
                [self.activityDetailsView updateProfileImage: [imgs imageFromCache:self.socializeActivity.user.smallImageUrl]];
            }copy] autorelease];
            
            [self.cache loadImageFromUrl:self.socializeActivity.user.smallImageUrl withLoader:[UrlImageLoader class] andCompleteAction:complete];
        }
    }
}


#pragma mark - activityviewcontroller methods
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
    //configure the socialize activity view
    [self updateProfileImage];
    self.activityDetailsView.username = self.socializeActivity.user.userName;
    
    //set the activity message on the activity view
    NSString *activityText = ((SocializeComment *)self.socializeActivity).text;
    [self.activityDetailsView updateActivityMessage:activityText 
                                   withActivityDate:self.socializeActivity.date];
    
    //initialize the data for the recent activity view
    [self.activityViewController initializeContent];
}
-(void)viewWillDisappear:(BOOL)animated
{   
    [super viewWillDisappear:animated];
    [self.cache stopOperations];
    
    [self.profileImageDownloader cancelDownload];
    self.profileImageDownloader = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.activityDetailsView.activityTableView = self.activityViewController.view;
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


@end
