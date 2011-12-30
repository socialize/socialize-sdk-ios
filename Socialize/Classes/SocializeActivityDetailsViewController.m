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
-(void)loadActivityDetailData;
-(void)updateProfileImage;
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
    //we have to release this property manually because it's readyonly
    [socializeActivity_ release];
    
    self.activityDetailsView = nil;
    self.profileImageDownloader = nil;
    self.activityViewController = nil;
    self.cache = nil;
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

#pragma mark fetching/setting socialize activity
-(void)fetchActivityForType:(NSString*)activityType activityID:(NSNumber*)activityID {
    //comments are currently the only type that exist
    [self.socialize getCommentById:[activityID intValue]];    
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray {
    if ([dataArray count]){
        id<SocializeObject> object = [dataArray objectAtIndex:0];
        if ([object conformsToProtocol:@protocol(SocializeActivity)]){
            //  do entity saving here. 
            //  All the entity related information can be fetched here ie stats or name.
            self.socializeActivity = (id<SocializeActivity>)object;
            [self loadActivityDetailData];
        }
    }
}

-(void)loadActivityDetailData {
    if(self.socializeActivity) {
        NSString *activityText = ((SocializeComment *)self.socializeActivity).text;
        [self.activityDetailsView updateActivityMessage:activityText 
                                       withActivityDate:self.socializeActivity.date];
        [self.activityViewController initializeContent];
        [self updateProfileImage];
        //once all the data is being loaded or fetched we can turn off the animation
        [self stopLoadAnimation];
    }
}

-(void)configureDetailsView {
    self.activityViewController.currentUser = self.socializeActivity.user.objectID;
    self.activityDetailsView.username = self.socializeActivity.user.userName;
    self.activityDetailsView.activityTableView = self.activityViewController.view;
}

-(void)setSocializeActivity:(id<SocializeActivity>)socializeActivity {
    if(socializeActivity_) {
        [socializeActivity_ release];
        socializeActivity_ = nil;
    }
    if( socializeActivity) {
        NSAssert([socializeActivity isKindOfClass:[SocializeComment class]], @"socialize activity details only  currently handles of type socialize comment, you passed in %@", [socializeActivity class]);
        //when the socialize activity changes we should also let the recent activity view controller
        //know that there is a new user for which to load recent activity.
        socializeActivity_ = [socializeActivity retain];
        [self configureDetailsView];
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
    [self loadActivityDetailData];
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
    [self startLoadAnimationForView:self.activityDetailsView];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
