//
//  SocializeActivityDetailsView.m
//  Socialize SDK
//
//  Created by Isaac on 12/6/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityDetailsView.h"
#import "HtmlPageCreator.h"
#import <QuartzCore/QuartzCore.h>

#define VIEW_OFFSET_SIZE 20
#define NO_LOCATION_MSG @"No location associated with this activity."
#define NO_CITY_MSG @"Could not locate the place name."
#define NO_COMMENT_MSG @"Could not load activity."

@interface SocializeActivityDetailsView()
-(void) configurateProfileImage;
@end

@implementation SocializeActivityDetailsView

@synthesize activityMessageView;
@synthesize profileNameButton;
@synthesize profileImage;
@synthesize recentActivityView;
@synthesize activityTableView;
@synthesize recentActivityHeaderImage;
@synthesize activityMessage;
@synthesize activityDate;
@synthesize username;
#pragma mark init/dealloc methods
- (void)dealloc
{

    activityMessageView.delegate = nil;
    [activityMessageView release]; activityMessageView = nil;
    [profileNameButton release]; profileNameButton = nil;
    [profileImage release]; profileImage = nil;
    [recentActivityView release]; recentActivityView = nil;
    [activityTableView release]; activityTableView = nil;
    [recentActivityHeaderImage release]; recentActivityHeaderImage = nil;
    [activityMessage release]; activityMessage = nil;
    [activityDate release]; activityDate = nil;
    [username release]; username = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self)
    {
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
    //this method should also be abstracted to a SocializeUIView when it exists
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
-(void) updateProfileImage: (UIImage* )image
{
    self.profileImage.image = image;
    [self configurateProfileImage];
}

-(void) setUsername:(NSString*)name {
    [self.profileNameButton setTitle:name forState:UIControlStateNormal];
}

#pragma mark activity message method webview
-(CGFloat)getMessageHeight {
    NSString *output = [activityMessageView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"wrapper\").offsetHeight;"];
    CGFloat height = [output floatValue];
    return height;
}

-(void)updateActivityMessage:(NSString *)newActivityMessage withActivityDate:(NSDate *)newActivityDate {
    self.activityMessage = newActivityMessage;
    self.activityDate = newActivityDate;
    [self updateActivityMessageView];
}
-(void) updateActivityMessageView {
    HtmlPageCreator* htmlCreator = [[HtmlPageCreator alloc]init];
    
    if([htmlCreator loadTemplate:[[NSBundle mainBundle] pathForResource:@"comment_template_clear" ofType:@"htm"]])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy 'at' h:mm a"];      
        [htmlCreator addInformation:[dateFormatter stringFromDate:self.activityDate] forTag:@"DATE_TEXT"];
        [dateFormatter release]; dateFormatter = nil;
        
        if(self.activityMessage)
        {        
            NSMutableString* activityText = [[[NSMutableString alloc] initWithString:self.activityMessage] autorelease];       
            [activityText replaceOccurrencesOfString: @"\n" withString:@"<br>" options:NSLiteralSearch range:NSMakeRange(0, [activityText length])];
            [htmlCreator addInformation:activityText forTag: @"COMMENT_TEXT"];
        }
        else
        {
            [htmlCreator addInformation:NO_COMMENT_MSG 
                                 forTag: @"COMMENT_TEXT"];    
        }
        
        [self.activityMessageView loadHTMLString:htmlCreator.html baseURL:nil];
    }
    else
    {
        // Could not create dynamic html for comment
        [self.activityMessageView loadHTMLString:self.activityMessage baseURL:nil];
    }
    [htmlCreator release];
    //we shouldn't do the layout here, we need to wait for webview to finish loading -- see delegate methods
} 


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self layoutActivityDetailsSubviews];
}


#pragma mark layout logic
//this method should be abstracted to a SocializeUIView when we write one. 
-(void) positionView:(UIView*)lowerView belowView:(UIView *)upperView
{
    CGFloat yCoord = upperView.frame.origin.y + upperView.frame.size.height;
    CGRect viewFrame = lowerView.frame;
    viewFrame.origin.y = yCoord;
    lowerView.frame = viewFrame;
}

-(void) layoutActivityDetailsSubviews
{    
    CGFloat messageHeight = [self getMessageHeight];
    //update comments height
    CGRect messageFrame = activityMessageView.frame;
    messageFrame.size.height = messageHeight;
    activityMessageView.frame = messageFrame;
    
    //adjust the activity view frame
    [self positionView:self.recentActivityView belowView:self.activityMessageView];
    //adjust all the activity subviews
    [self layoutRecentActivitySubviews];
    
    CGFloat height = self.recentActivityView.frame.origin.y + self.recentActivityView.frame.size.height;
    self.contentSize = CGSizeMake(self.frame.size.width, height);
}

#pragma mark activity view layout
-(void) layoutRecentActivitySubviews { 
    [self positionView:self.activityTableView belowView:self.recentActivityHeaderImage];
    
    //we also need to give the tableview the correct height
    CGFloat activityHeight = self.recentActivityView.frame.size.height - self.recentActivityHeaderImage.frame.size.height;
    CGRect newActivityFrame = self.activityTableView.frame;
    newActivityFrame.size.height = activityHeight;
    self.activityTableView.frame = newActivityFrame;
}
-(void) setActivityTableView:(UIView *)newActivityTableView {
    if( activityTableView ) {
        //we need to remove the previous view from the hierarchy
        [activityTableView removeFromSuperview];
        [activityTableView release];
        activityTableView = nil;
    }
    if ( newActivityTableView ) {
        activityTableView = [newActivityTableView retain];
        //we also need to set the correct frame when we add the object as a subview
        [self.recentActivityView addSubview:activityTableView];
        [self layoutActivityDetailsSubviews];
    }
}

@end
