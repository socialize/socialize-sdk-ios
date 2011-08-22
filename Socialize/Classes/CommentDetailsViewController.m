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
//#import "UIButton+Socialize.h"
//#import "UILabel-Additions.h"
//#import "HtmlPageCreator.h"
//#import "UIView+RoundedCorner.h"
//#import "URLDownload.h"

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define NO_LOCATION_MSG @"No location associated with this comment."
#define NO_CITY_MSG @"Could not locate the place name."
#define NO_COMMENT_MSG @"Could not load comment."

#define kCenterPointLatitude  37.779941
#define kCenterPointLongitude -122.417908

#define kSpanDeltaLatitude    0.0025
#define kSpanDeltaLongitude   0.0025

//@interface CommentDetailsViewController()
//
////    @property(nonatomic, retain) URLDownload* profileImageDownloader;
//    @property(nonatomic, retain) MKReverseGeocoder *geoCoder;
//
//    -(UIBarButtonItem*) initLeftNavigationButtonWithCaption: (NSString*) caption;
//    -(void) showComment;
//    -(void) setLocationText: (NSString*) text;
//    -(void) setupUserName;
//@end

@implementation CommentDetailsViewController

@synthesize commentDetailsView;
//@synthesize entryComment;
//@synthesize profileImageDownloader;
//@synthesize geoCoder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
//    [geoCoder release]; geoCoder = nil;
//    [profileImageDownloader release]; profileImageDownloader = nil;
//    [commentDetailsView release]; commentDetailsView = nil;
//    [entryComment release]; entryComment = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark user location



//-(void) setLocationText: (NSString*) text
//{
//    commentDetailsView.positionLable.text = text;
//    commentDetailsView.positionLable.textColor = [UIColor whiteColor];
//    commentDetailsView.positionLable.layer.shadowColor = [UIColor blackColor].CGColor;
//    commentDetailsView.positionLable.layer.shadowOffset = CGSizeMake(0.0, 1.0);
//    
//    commentDetailsView.positionLable.layer.masksToBounds = NO;
//}
//
//-(void) setupCommentGeoLocation
//{
//    //CLLocationCoordinate2D centerPoint = {kCenterPointLatitude, kCenterPointLongitude}; //Demo value
//	
//    
//    CLLocationCoordinate2D centerPoint = {[self.entryComment.geoPoint.lat doubleValue], 
//        [self.entryComment.geoPoint.lng doubleValue]};     
//    
//    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(kSpanDeltaLatitude, kSpanDeltaLongitude);
//    
//    [commentDetailsView.mapOfUserLocation setFitLocation: centerPoint withSpan: coordinateSpan];
//    [commentDetailsView.mapOfUserLocation setAnnotationOnPoint: centerPoint];
//    
//    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
//    self.geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:centerPoint];
//    self.geoCoder.delegate = self;
//    [self.geoCoder start];
//}
//
//-(void)showShareLocation:(BOOL)hasLocation
//{
//    commentDetailsView.showMap = hasLocation;
//   
//    if (hasLocation) 
//    {
//        [self setupCommentGeoLocation];
//        commentDetailsView.navImage.image = [UIImage imageNamed:@"socialize_resources/socialize-comment-details-icon-geo-enabled.png"]; 
//    }
//    else
//    {
//        commentDetailsView.positionLable.text = NO_LOCATION_MSG;
//        commentDetailsView.positionLable.textColor = [UIColor colorWithRed:127/ 255.f green:139/ 255.f blue:147/ 255.f alpha:1.0];
//        commentDetailsView.positionLable.font = [UIFont fontWithName:@"Helvetica-Oblique" size:12];
//        commentDetailsView.navImage.image = [UIImage imageNamed:@"socialize_resources/socialize-comment-details-icon-geo-disabled.png"]; 
//    }  
//}
//
//#pragma mark - View lifecycle
//
//- (void) updateProfileImage:(NSData *)data urldownload:(URLDownload *)urldownload tag:(NSObject *)tag 
//{
//	if (data!= nil) 
//	{
//		UIImage *profileImage = [UIImage imageWithData:data];
//		[commentDetailsView updateProfileImage: profileImage];
//	}
//}
//
//-(void) showComment
//{   
//    HtmlPageCreator* htmlCreator = [[HtmlPageCreator alloc]init];
//
//    if([htmlCreator loadTemplate:[[NSBundle mainBundle] pathForResource:@"socialize_resources/comment_template_clear" ofType:@"htm"]])
//    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy 'at' h:mm a"];      
//        [htmlCreator addInformation:[dateFormatter stringFromDate:entryComment.date] forTag:@"DATE_TEXT"];
//        [dateFormatter release]; dateFormatter = nil;
//        
//        if(entryComment.commentText)
//        {        
//            NSMutableString* comment = [[[NSMutableString alloc] initWithString:entryComment.commentText] autorelease];       
//            [comment replaceOccurrencesOfString: @"\n" withString:@"<br>" options:NSLiteralSearch range:NSMakeRange(0, [comment length])];
//            [htmlCreator addInformation:comment forTag: @"COMMENT_TEXT"];
//        }
//        else
//        {
//            [htmlCreator addInformation:NO_COMMENT_MSG 
//                                 forTag: @"COMMENT_TEXT"];    
//        }
//        
//        [commentDetailsView.commentMessage loadHTMLString:htmlCreator.html baseURL:nil];
//        
//    }else
//    {
//        NSLog(@"Could not create dynamic html for comment");
//        [commentDetailsView.commentMessage loadHTMLString:entryComment.commentText baseURL:nil];
//    }
//    
//    [htmlCreator release];
//}
//
//-(void)setupUserName
//{
//    commentDetailsView.profileNameLable.text = entryComment.username;
//    commentDetailsView.profileNameLable.textColor = [UIColor colorWithRed:217/ 255.f green:225/ 255.f blue:232/ 255.f alpha:1.0];
//    commentDetailsView.profileNameLable.layer.shadowOpacity = 0.9;   
//    commentDetailsView.profileNameLable.layer.shadowRadius = 1.0;
//    commentDetailsView.profileNameLable.layer.shadowColor = [UIColor blackColor].CGColor;
//    commentDetailsView.profileNameLable.layer.shadowOffset = CGSizeMake(0.0, -1.0);
//    
//    commentDetailsView.profileNameLable.layer.masksToBounds = NO;    
//}

-(void)viewWillAppear:(BOOL)animated
{ 
//    [self setupUserName];
//    [self showComment];  
//    [self.commentDetailsView configurateProfileImage];
//    [self.commentDetailsView.mapOfUserLocation configurate];
}

-(void)viewWillDisappear:(BOOL)animated
{   
//    self.geoCoder.delegate = nil;
//    [self.geoCoder cancel];
//    
//    [self.profileImageDownloader cancelDownload];
//    self.profileImageDownloader = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    //temp value
//    BOOL commentHasLocation = (self.entryComment.geoPoint != nil);
//    //
//    
//    [self showShareLocation: commentHasLocation];
//
//    if([entryComment.userImageURL length]>0)
//    {
//        profileImageDownloader = [[URLDownload alloc] initWithURL:entryComment.userImageURL sender:self 
//                                                      selector:@selector(updateProfileImage:urldownload:tag:) 
//                                                      tag:nil];
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - touche events

//-(UIBarButtonItem*) initLeftNavigationButtonWithCaption: (NSString*) caption
//{
//    UIButton *backButton = [UIButton blackSocializeNavBarBackButtonWithTitle:caption]; 
//    [backButton addTarget:self action:@selector(backToCommentsList:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * backLeftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    return backLeftItem;
//}
//
//-(void)backToCommentsList:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - geo coordinates
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
//{   
//    NSString * state = placemark.administrativeArea;
//    NSString * city =  placemark.locality;
//    NSString * neighborhood = placemark.subLocality;
//    
//    
//    if (neighborhood && ([neighborhood length] > 0))
//    {   
//        [self setLocationText: [NSString stringWithFormat:@"%@, %@", neighborhood,city]];
//    }
//    else if (city && ([city length]>0))
//    {
//        [self setLocationText:[NSString stringWithFormat:@"%@, %@", city,state]];
//    }
//
//    [geocoder autorelease];
//}
//
//// this delegate is called when the reversegeocoder fails to find a placemark
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
//{
//    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
//    
//    [self setLocationText: NO_CITY_MSG];
//    
//    [geocoder autorelease];
//}

@end
