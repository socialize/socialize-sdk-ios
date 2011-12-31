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
#import "UIView+Layout.h"
#import "PropertyHelpers.h"

CGFloat const kActivityDetailViewOffset = 20;
CGFloat const kMinRecentActivityHeight = 200;
CGFloat const kMinActivityMessageHeight = 50;

NSString * const kNoLocationMessage = @"No location associated with this activity.";
NSString * const kNoCityMessage = @"Could not locate the place name.";
NSString * const kNoCommentMessage = @"Could not load activity.";

@interface SocializeActivityDetailsView()
-(void) configureProfileImage;
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
@synthesize recentActivityLabel;
@synthesize dateFormatter;
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
    [recentActivityLabel release]; recentActivityLabel = nil;
    [dateFormatter release]; dateFormatter = nil;
    
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

-(void) configureProfileImage
{
    self.profileImage.layer.cornerRadius = 3.0;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 1.0;
    
    [self addShadowForView:self.profileImage];
}
-(void) updateProfileImage: (UIImage* )image
{
    self.profileImage.image = image;
    [self configureProfileImage];
}

-(void) setUsername:(NSString*)name {
    NonatomicRetainedSetToFrom(username, name);
    if(username) {
        [self.profileNameButton setTitle:username forState:UIControlStateNormal];
        self.recentActivityLabel.text = [NSString stringWithFormat:@"%@'s Recent Activity", username];
    }
}

#pragma mark activity message method webview
-(CGFloat)getMessageHeight {
    NSString *output = [activityMessageView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"wrapper\").offsetHeight;"];
    CGFloat height = [output floatValue];
    if( height < kMinActivityMessageHeight ) {
        return kMinActivityMessageHeight;
    } else {
        return height;
    }
}

-(void)updateActivityMessage:(NSString *)newActivityMessage withActivityDate:(NSDate *)newActivityDate {
    self.activityMessage = newActivityMessage;
    self.activityDate = newActivityDate;
    [self updateActivityMessageView];
}

-(NSDateFormatter *) dateFormatter {
    if( dateFormatter == nil ) {
        dateFormatter =  [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy 'at' h:mm a"];      
    }
    return dateFormatter;
}

-(void) updateActivityMessageView {
    HtmlPageCreator* htmlCreator = [[HtmlPageCreator alloc]init];
    
    if([htmlCreator loadTemplate:[[NSBundle mainBundle] pathForResource:@"comment_template_clear" ofType:@"htm"]])
    {
        [htmlCreator addInformation:[self.dateFormatter stringFromDate:self.activityDate] forTag:@"DATE_TEXT"];
        
        if(self.activityMessage)
        {        
            NSMutableString* activityText = [[[NSMutableString alloc] initWithString:self.activityMessage] autorelease];       
            [activityText replaceOccurrencesOfString: @"\n" withString:@"<br>" options:NSLiteralSearch range:NSMakeRange(0, [activityText length])];
            [htmlCreator addInformation:activityText forTag: @"COMMENT_TEXT"];
        }
        else
        {
            [htmlCreator addInformation:kNoCommentMessage forTag: @"COMMENT_TEXT"];    
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
-(void) layoutActivityDetailsSubviews
{    
    CGFloat messageHeight = [self getMessageHeight];
    //update comments height
    CGRect messageFrame = activityMessageView.frame;
    messageFrame.size.height = messageHeight;
    activityMessageView.frame = messageFrame;
    
    // adjust the activity view frame below the activity message
    [self.recentActivityView positionBelowView:self.activityMessageView];
    
    // fill out the remaining view with the recent activity view
    [self.recentActivityView fillRestOfView:self minSize:CGSizeMake(self.frame.size.width,kMinRecentActivityHeight)];
    
    //adjust all the activity subviews
    [self layoutRecentActivitySubviews];
    
    self.contentSize = CGSizeMake(self.frame.size.width, self.recentActivityView.diagonalPoint.y);
}

#pragma mark activity view layout
-(void) layoutRecentActivitySubviews { 
    [self.activityTableView positionBelowView:self.recentActivityHeaderImage];
    
    //we also need to give the tableview the correct height so we'll take the bottom most view
    CGFloat activityHeight = self.recentActivityView.frame.size.height - self.recentActivityHeaderImage.frame.size.height;
    CGRect newActivityFrame = self.activityTableView.frame;
    newActivityFrame.size.height = activityHeight;
    self.activityTableView.frame = newActivityFrame;
}
-(void) setActivityTableView:(UIView *)newActivityTableView {
    if( activityTableView ) {
        //we need to remove the previous view from
        //the hierarchy before adding a new one later
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
