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
#import "UIButton+Socialize.h"
#import "_Socialize.h"
#import "UIDevice+VersionCheck.h"
#import "SocializeActivityDetailsViewIOS6.h"

CGFloat const kMinActivityMessageHeight = 50;

NSString * const kNoLocationMessage = @"No location associated with this activity.";
NSString * const kNoCityMessage = @"Could not locate the place name.";
NSString * const kNoCommentMessage = @"Could not load activity.";

@interface SocializeActivityDetailsView()
@end

@implementation SocializeActivityDetailsView

@synthesize activityMessageView;
@synthesize profileNameButton;
@synthesize profileImage;
@synthesize recentActivityView;
@synthesize recentActivityHeaderImage = recentActivityHeaderImage_;
@synthesize activityMessage;
@synthesize activityDate;
@synthesize activity = activity_;
@synthesize username;
@synthesize recentActivityLabel;
@synthesize dateFormatter;
@synthesize htmlPageCreator;
@synthesize showEntityView = showEntityView_;
@synthesize showEntityButton = showEntityButton_;
@synthesize delegate = delegate_;
@synthesize locationTextLabel = _locationTextLabel;
@synthesize locationPinButton = _locationPinButton;
@synthesize locationFatButton = _locationFatButton;

//class cluster for iOS 6 compatibility
+ (id)alloc {
    if([self class] == [SocializeActivityDetailsView class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [SocializeActivityDetailsViewIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

#pragma mark init/dealloc methods
- (void)dealloc {
    activityMessageView.delegate = nil;
    [activityMessageView release];
    [profileNameButton release];
    [profileImage release]; 
    [recentActivityView release]; 
    [recentActivityHeaderImage_ release];
    [activityMessage release];
    [activityDate release]; 
    [activity_ release];
    [username release]; 
    [recentActivityLabel release];
    [dateFormatter release]; 
    [htmlPageCreator release];
    [showEntityView_ release];
    [showEntityButton_ release];
    [_locationTextLabel release];
    [_locationPinButton release];
    [_locationFatButton release];
    
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self) {
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

- (void)awakeFromNib {
    UIImage *entityImage = [[UIImage imageNamed:@"socialize-activity-details-btn-link-ios7.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.showEntityButton setBackgroundImage:entityImage forState:UIControlStateNormal];
}

-(void) addShadowForView:(UIView*)view {
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

-(void) updateProfileImage: (UIImage* )image {
    self.profileImage.image = image;
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

- (void)setActivity:(id<SocializeActivity>)activity {
    NonatomicRetainedSetToFrom(activity_, activity);
    NSAssert([activity conformsToProtocol:@protocol(SocializeComment)], @"Only comments are supported");
    id<SocializeComment> comment = (id<SocializeComment>)activity;
    NSString *activityText = comment.text;
    [self updateActivityMessage:activityText 
                                   withActivityDate:comment.date];

}

-(NSDateFormatter *) dateFormatter {
    if( dateFormatter == nil ) {
        dateFormatter =  [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy 'at' h:mm a"];      
    }
    return dateFormatter;
}

-(HtmlPageCreator *) htmlCreator {
    if( htmlPageCreator == nil ) {
        htmlPageCreator = [[HtmlPageCreator alloc]init];
    }
    return htmlPageCreator;
}

-(void) updateActivityMessageView {
    [self.htmlCreator loadTemplate:[[NSBundle mainBundle] pathForResource:@"comment_template_clear" ofType:@"htm"]];
    [self.htmlCreator addInformation:[self.dateFormatter stringFromDate:self.activityDate] forTag:@"DATE_TEXT"];
        
    NSMutableString* activityText = [[[NSMutableString alloc] initWithString:self.activityMessage] autorelease];       
    [activityText replaceOccurrencesOfString: @"\n" withString:@"<br>" options:NSLiteralSearch range:NSMakeRange(0, [activityText length])];
    [self.htmlCreator addInformation:activityText forTag: @"COMMENT_TEXT"];
    [self.activityMessageView loadHTMLString:htmlPageCreator.html baseURL:nil];
    //we shouldn't do the layout here, we need to wait for webview to finish loading -- see delegate methods
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self layoutActivityDetailsSubviews];
    
    [self.delegate activityDetailsViewDidFinishLoad:self];
}

#pragma mark layout logic
-(void) layoutActivityDetailsSubviews {
    CGFloat messageHeight = [self getMessageHeight];
    //update comments height
    CGRect messageFrame = activityMessageView.frame;
    messageFrame.size.height = messageHeight;
    activityMessageView.frame = messageFrame;

    BOOL haveEntityLoader = [Socialize entityLoaderBlock] != nil;
    BOOL entityLoadRejected = [Socialize canLoadEntityBlock] != nil && ![Socialize canLoadEntityBlock](self.activity.entity);
    BOOL canLoadEntity = haveEntityLoader && !entityLoadRejected;

    if (canLoadEntity) {
        // Show entity is below the variable-height activity message view
        [self addSubview:self.showEntityView];
        [self.showEntityView positionBelowView:self.activityMessageView];
        
        // Activity view is below the show entity view
        [self.recentActivityView positionBelowView:self.showEntityView];
    } else {
        [self.showEntityView removeFromSuperview];
        
        // Activity view is below the show entity view
        [self.recentActivityView positionBelowView:self.activityMessageView];
    }
        
    CGRect thisFrame = self.bounds;
    CGPoint botRight = self.recentActivityView.diagonalPoint;
    CGFloat newHeight = botRight.y;
    thisFrame.size.height = newHeight;
    self.bounds = thisFrame;
}

#pragma mark activity view layout

@end
