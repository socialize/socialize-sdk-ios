//
//  EntryViewController.m
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "EntryViewController.h"

#define ACTION_PANE_HEIGHT 44

@interface EntryViewController() 
    -(void) initSocialize;
    @property (nonatomic, retain) SocializeActionView* socializeActionPanel;
    @property (nonatomic, retain) UIWebView* webView;
@end

@implementation EntryViewController

@synthesize socializeActionPanel = _socializeActionPanel;
@synthesize webView = _webView;

- (void)dealloc
{
    [_socializeActionPanel release]; _socializeActionPanel = nil;
    [_webView release]; _webView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.autoresizesSubviews = YES;
	self.view.backgroundColor = [UIColor whiteColor];
	
	
	UIWebView *newWebView = [[UIWebView alloc] init];
	
	self.webView = newWebView;
	[newWebView release];
    
	self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
	
	[self.view addSubview: self.webView];
    
	self.webView.delegate = self;
	self.webView.scalesPageToFit = YES;
	self.webView.dataDetectorTypes = UIDataDetectorTypeLink;

	//initialize socialize related classes
	[self initSocialize];   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    self.socializeActionPanel = nil;
}

-(void) initSocialize
{       
    self.socializeActionPanel = [[SocializeActionView alloc] initWithFrame:
                                 CGRectMake(0,
                                            self.view.bounds.size.height - ACTION_PANE_HEIGHT, 
                                            self.view.bounds.size.height,
                                            ACTION_PANE_HEIGHT)
                                 ];
    self.socializeActionPanel.opaque = NO;
    self.socializeActionPanel.alpha = 0.9;
    self.socializeActionPanel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.socializeActionPanel.autoresizesSubviews = YES;
    self.socializeActionPanel.delegate = self;
    
    //Demo value
    [self.socializeActionPanel updateCountsWithViewsCount:[NSNumber numberWithInt:100] withLikesCount:[NSNumber numberWithInt:5] withCommentsCount:[NSNumber numberWithInt:3]];
    
    [self.view addSubview:self.socializeActionPanel];
        
    [self.socializeActionPanel setNeedsDisplay];       
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

@end
