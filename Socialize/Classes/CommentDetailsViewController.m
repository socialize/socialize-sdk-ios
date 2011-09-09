//
//  CommentDetailsViewController.m
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "CommentDetailsViewController.h"
#import "SocializeComment.h"
#import "CommentDetailsView.h"
#import "CommentMapView.h"
#import "UIButton+Socialize.h"
#import "UILabel-Additions.h"
#import "HtmlPageCreator.h"
#import "URLDownload.h"
#import "NSString+PlaceMark.h"
#import "ImagesCache.h"

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define NO_LOCATION_MSG @"No location associated with this comment."
#define NO_CITY_MSG @"Could not locate the place name."
#define NO_COMMENT_MSG @"Could not load comment."

#define kCenterPointLatitude  37.779941
#define kCenterPointLongitude -122.417908


@interface CommentDetailsViewController()

@property(nonatomic, retain) MKReverseGeocoder *geoCoder;
-(void) showComment;
-(void) setupCommentGeoLocation;
-(void) showShareLocation:(BOOL)hasLocation;

@end

@implementation CommentDetailsViewController

@synthesize commentDetailsView;
@synthesize comment;
@synthesize geoCoder;
@synthesize profileImageDownloader;
@synthesize loaderFactory;
@synthesize cache;

- (void)dealloc
{
    [geoCoder release]; geoCoder = nil;
    [commentDetailsView release]; commentDetailsView = nil;
    [comment release]; comment = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark user location

-(void)setupCommentGeoLocation
{
    CLLocationCoordinate2D centerPoint = {[self.comment.lat doubleValue], 
        [self.comment.lng doubleValue]};     
    

    
    [commentDetailsView updateGeoLocation: centerPoint];
    
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    MKReverseGeocoder* geo = [[MKReverseGeocoder alloc] initWithCoordinate:centerPoint];
    self.geoCoder = geo;
    [geo release]; geo = nil;
    self.geoCoder.delegate = self;
    [self.geoCoder start];
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
        NSLog(@"Could not create dynamic html for comment");
        [commentDetailsView updateCommentMsg:comment.text];
    }
    
    [htmlCreator release];
}

-(void)updateProfileImage
{
    CompleteBlock compete = [[^(ImagesCache* imgs){
        [commentDetailsView updateProfileImage: [imgs imageFromCache:self.comment.user.smallImageUrl]];
    }copy] autorelease];
    cache.completeAction = compete;
    
    if(self.comment.user.smallImageUrl != nil && [self.comment.user.smallImageUrl length]>0)
    {
        UIImage* image = [cache imageFromCache:self.comment.user.smallImageUrl];
        if(image)
            [commentDetailsView updateProfileImage: image];
        else
            [cache loadImageFromUrl:self.comment.user.smallImageUrl];
    }
}

-(void)viewWillAppear:(BOOL)animated
{ 
    [self updateProfileImage];
    [self.commentDetailsView updateUserName:comment.user.userName];
    [self showComment];
    [self.commentDetailsView configurateView];
}

-(void)viewWillDisappear:(BOOL)animated
{   
    self.geoCoder.delegate = nil;
    [self.geoCoder cancel];
    [cache stopOperations];
    
    [self.profileImageDownloader cancelDownload];
    self.profileImageDownloader = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showShareLocation:self.comment.lat != nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - geo coordinates
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{   
    [commentDetailsView updateLocationText:[NSString stringWithPlacemark:placemark]];
}
//
//// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
    
    [commentDetailsView updateLocationText: NO_CITY_MSG];   
}

@end
