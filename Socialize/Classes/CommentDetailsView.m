//
//  CommentDetailsView.m
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "CommentDetailsView.h"
#import "CommentMapView.h"
#import <QuartzCore/QuartzCore.h>

#define VIEW_OFSET_SIZE 20
#define GEO_LABLE_OFSSET 9

@interface CommentDetailsView()
-(void) updateComponentsLayoutWithCommentViewHeight: (CGFloat) height;
-(void) configurateProfileImage;
-(void) moveSubview: (UIView*) subView onValue: (CGFloat) value;
-(CGFloat) desideSize;
@end

@implementation CommentDetailsView

@synthesize commentMessage;
@synthesize mapOfUserLocation;
@synthesize navImage;
@synthesize positionLable;
@synthesize showMap;
@synthesize profileNameButton;
@synthesize profileImage;
@synthesize shadowBackground;
@synthesize shadowMapOfUserLocation;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self)
    {
        //self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        self.backgroundColor = [UIColor colorWithRed:65/ 255.f green:77/ 255.f blue:86/ 255.f alpha:1.0];
        
        
        self.profileNameButton.titleLabel.textColor = [UIColor colorWithRed:217/ 255.f green:225/ 255.f blue:232/ 255.f alpha:1.0];
        self.profileNameButton.titleLabel.layer.shadowOpacity = 0.9;   
        self.profileNameButton.titleLabel.layer.shadowRadius = 1.0;
        self.profileNameButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.profileNameButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        self.profileNameButton.titleLabel.layer.masksToBounds = NO; 
        
        
        

    }
    return self;
}

-(void) addShadowForView:(UIView*)view
{
    UIView* shadowView = [[UIView alloc] init];
    shadowView.layer.cornerRadius = 3.0;
    shadowView.layer.shadowColor = [UIColor colorWithRed:22/ 255.f green:28/ 255.f blue:31/ 255.f alpha:1.0].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadowView.layer.shadowOpacity = 0.9f;
    shadowView.layer.shadowRadius = 3.0f;
    [shadowView addSubview:view];
    
    [self addSubview:shadowView];
    [shadowView release];
}

-(void) configurateProfileImage
{
    self.profileImage.layer.cornerRadius = 3.0;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 1.0;
    
    [self addShadowForView:self.profileImage];
}

-(void)configurateView
{
    [self configurateProfileImage];
    [self.mapOfUserLocation roundCorners];
    
    shadowMapOfUserLocation.layer.cornerRadius = 3.0;
    shadowMapOfUserLocation.layer.shadowColor = [UIColor colorWithRed:22/ 255.f green:28/ 255.f blue:31/ 255.f alpha:1.0].CGColor;
    shadowMapOfUserLocation.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadowMapOfUserLocation.layer.shadowOpacity = 0.9f;
    shadowMapOfUserLocation.layer.shadowRadius = 3.0f;
}

-(void) updateProfileImage: (UIImage* )image
{
    self.profileImage.image = image;
    [self configurateProfileImage];
}

-(void) updateLocationText: (NSString*)text
{
    self.positionLable.text = text;
    self.positionLable.textColor = [UIColor whiteColor];
    self.positionLable.layer.shadowColor = [UIColor blackColor].CGColor;
    self.positionLable.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.positionLable.layer.masksToBounds = NO;
}

-(void) updateLocationText: (NSString*)text color: (UIColor*) color fontName: (NSString*) font fontSize: (CGFloat)size
{
    self.positionLable.text = text;
    self.positionLable.textColor = color;
    self.positionLable.font = [UIFont fontWithName:font size:size];
}

-(void) updateNavigationImage: (UIImage*)image
{
    self.navImage.image = image;
}

-(void) updateUserName: (NSString*)name
{
    [self.profileNameButton setTitle:name forState:UIControlStateNormal];
}

-(void) updateGeoLocation: (CLLocationCoordinate2D) location
{
    [self.mapOfUserLocation setFitLocation: location withSpan: [CommentMapView coordinateSpan]];
    [self.mapOfUserLocation setAnnotationOnPoint: location];
}

-(void) updateCommentMsg: (NSString*)comment
{
    [self.commentMessage loadHTMLString:comment baseURL:nil];
}

-(void) moveSubview: (UIView*) subView onValue: (CGFloat) value 
{
    CGRect viewFrame = subView.frame;
    viewFrame.origin.y = value;
    subView.frame = viewFrame;
}

- (CGFloat) desideSize
{
    return navImage.frame.origin.y + navImage.frame.size.height;
}

-(void) updateComponentsLayoutWithCommentViewHeight: (CGFloat) height
{    
    CGRect commentFrame = commentMessage.frame;
    commentFrame.size.height = height;
    commentMessage.frame = commentFrame;
    
    if(showMap){
        [self moveSubview: shadowBackground onValue: commentMessage.frame.origin.y + commentMessage.frame.size.height];
        [self moveSubview: shadowMapOfUserLocation onValue: commentMessage.frame.origin.y + commentMessage.frame.size.height + VIEW_OFSET_SIZE];
        [self moveSubview: navImage onValue: shadowMapOfUserLocation.frame.origin.y + shadowMapOfUserLocation.frame.size.height + GEO_LABLE_OFSSET];
        [self moveSubview: positionLable onValue: shadowMapOfUserLocation.frame.origin.y + shadowMapOfUserLocation.frame.size.height + GEO_LABLE_OFSSET]; 
    }
    else {
        [self.shadowMapOfUserLocation removeFromSuperview];
        self.shadowMapOfUserLocation = nil;
        
        [self moveSubview: shadowBackground onValue: commentMessage.frame.origin.y + commentMessage.frame.size.height];
        [self moveSubview: navImage onValue: commentMessage.frame.origin.y + commentMessage.frame.size.height + VIEW_OFSET_SIZE];
        [self moveSubview: positionLable onValue: commentMessage.frame.origin.y + commentMessage.frame.size.height + VIEW_OFSET_SIZE];   
    }
    
    CGFloat newHeight = [self desideSize];
    if(newHeight > self.frame.size.height){
        
        CGRect selfFrame = self.frame;
        selfFrame.size.height = newHeight + VIEW_OFSET_SIZE;
        self.contentSize = selfFrame.size;
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"wrapper\").offsetHeight;"];
    [self updateComponentsLayoutWithCommentViewHeight: [output floatValue]];
}

- (void)dealloc
{
    commentMessage.delegate = nil;
    [commentMessage release]; commentMessage = nil;
    [mapOfUserLocation release]; mapOfUserLocation = nil;
    [navImage release]; navImage = nil;
    [profileNameButton release]; profileNameButton = nil;
    [positionLable release]; positionLable = nil;
    [profileImage release]; profileImage = nil;
    [shadowBackground release]; shadowBackground = nil;
    [shadowMapOfUserLocation release]; shadowMapOfUserLocation = nil;
    
    [super dealloc];
}

@end
