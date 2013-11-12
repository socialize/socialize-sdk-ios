//
//  CommentDetailsViewController.m
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeCommentDetailsViewController.h"
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

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define NO_LOCATION_MSG @"No location associated with this comment."
#define NO_CITY_MSG @"Could not locate the place name."
#define NO_COMMENT_MSG @"Could not load comment."

#define kCenterPointLatitude  37.779941
#define kCenterPointLongitude -122.417908


@implementation SocializeCommentDetailsViewController

@synthesize commentDetailsView;
@synthesize comment;
@synthesize profileImageDownloader;
@synthesize cache;
@synthesize profileLabelButton = profileLabelButton_;

- (void)dealloc
{
    [commentDetailsView release]; commentDetailsView = nil;
    [comment release]; comment = nil;
    [cache release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle *)nibBundleOrNil{
    if ((self = [super initWithNibName:nibName bundle:nibBundleOrNil])) {
    }
    return self;
}

#pragma mark user location

-(void)setupCommentGeoLocation
{
    CLLocation* location = [[[CLLocation alloc]initWithLatitude:[self.comment.lat doubleValue] longitude:[self.comment.lng doubleValue]]autorelease];
    
    [commentDetailsView updateGeoLocation: location.coordinate];
    
    __block SocializeGeocoderAdapter* adapter = [[SocializeGeocoderAdapter alloc] init];
    [adapter reverseGeocodeLocation:location completionHandler:^(NSArray*placemarks, NSError *error)
     {
         if(error)
         {
             [commentDetailsView updateLocationText: NO_CITY_MSG];
         }
         else
         {
             [commentDetailsView updateLocationText:[NSString stringWithPlacemark:[placemarks objectAtIndex:0]]];
         }    
         [adapter autorelease];
     }
    ];
}
-(IBAction)profileButtonTapped:(id)sender {
    _SZUserProfileViewController *profileViewController = [self getProfileViewControllerForUser:self.comment.user];
    profileViewController.navigationItem.leftBarButtonItem = [self createLeftNavigationButtonWithCaption:@"Comment"];
    [self.navigationController pushViewController:(UIViewController *)profileViewController animated:YES];
}
-(_SZUserProfileViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user {
    _SZUserProfileViewController *profileViewController = [_SZUserProfileViewController profileViewController];
    profileViewController.user = user;
    profileViewController.delegate = self;
    return profileViewController;
}
-(void)showShareLocation:(BOOL)hasLocation
{
    commentDetailsView.showMap = hasLocation;
    if (hasLocation) 
    {
        [self setupCommentGeoLocation];
        [commentDetailsView updateNavigationImage:[UIImage imageNamed:@"socialize-comment-details-icon-geo-enabled.png"]];
    }
    else
    {
        [commentDetailsView updateLocationText: NO_LOCATION_MSG 
                                         color: [UIColor colorWithRed:127/ 255.f green:139/ 255.f blue:147/ 255.f alpha:1.0] 
                                          fontName:@"Helvetica-Oblique" 
                                          fontSize:12];
        [commentDetailsView updateNavigationImage:[UIImage imageNamed:@"socialize-comment-details-icon-geo-disabled.png"]]; 
    }  
}

#pragma mark - View lifecycle

-(void) showComment
{   
    HtmlPageCreator* htmlCreator = [[HtmlPageCreator alloc]init];

    if([htmlCreator loadTemplate:[[NSBundle mainBundle] pathForResource:@"comment_template_clear" ofType:@"htm"]])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy 'at' h:mm a"];      
        [htmlCreator addInformation:[dateFormatter stringFromDate:comment.date] forTag:@"DATE_TEXT"];
        [dateFormatter release]; dateFormatter = nil;
        
        if(comment.text)
        {        
            NSMutableString* commentText = [[[NSMutableString alloc] initWithString:comment.text] autorelease];       
            [commentText replaceOccurrencesOfString: @"\n" withString:@"<br>" options:NSLiteralSearch range:NSMakeRange(0, [commentText length])];
            [htmlCreator addInformation:commentText forTag: @"COMMENT_TEXT"];
        }
        else
        {
            [htmlCreator addInformation:NO_COMMENT_MSG 
                                 forTag: @"COMMENT_TEXT"];    
        }
        
        [commentDetailsView updateCommentMsg:htmlCreator.html];
    }
    else
    {
        // Could not create dynamic html for comment
        [commentDetailsView updateCommentMsg:comment.text];
    }
    
    [htmlCreator release];
}
- (void)profileViewControllerDidCancel:(_SZUserProfileViewController*)profileViewController {
    //implement
}
- (void)profileViewControllerDidSave:(_SZUserProfileViewController*)profileViewController {
        //implement
}

-(void)updateProfileImage
{
    if(self.comment.user.smallImageUrl != nil && [self.comment.user.smallImageUrl length]>0)
    {
        UIImage* image = [cache imageFromCache:self.comment.user.smallImageUrl];
        if(image)
        {
            [commentDetailsView updateProfileImage: image];
        }
        else
        {
            CompleteBlock complete = [[^(ImagesCache* imgs){
                [commentDetailsView updateProfileImage: [imgs imageFromCache:self.comment.user.smallImageUrl]];
            }copy] autorelease];
            
            [cache loadImageFromUrl:self.comment.user.smallImageUrl withLoader:[UrlImageLoader class] andCompleteAction:complete];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{ 
    [super viewWillAppear:animated];
    [self updateProfileImage];
    [self.commentDetailsView updateUserName:comment.user.displayName]; //comment.user.userName
    [self showComment];
    [self.commentDetailsView configurateView];
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
    [self showShareLocation:self.comment.lat != nil];

    [self.profileLabelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
