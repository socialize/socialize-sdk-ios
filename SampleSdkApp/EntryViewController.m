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
    @property (nonatomic, retain) DemoEntry* entry;
@end

@implementation EntryViewController

@synthesize socializeActionPanel = _socializeActionPanel;
@synthesize webView = _webView;
@synthesize entry = _entry;

-(id) initWithEntry: (DemoEntry*) entry
{
    self = [super init];
    if(self != nil)
    {
        self.entry = entry;
    }
    return self;
}

- (void)dealloc
{
    [_socializeActionPanel release]; _socializeActionPanel = nil;
    [_webView release]; _webView = nil;
    [_entry release]; _entry = nil;
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
	
    self.webView = [[UIWebView alloc] initWithFrame: CGRectMake(0,
                                                                0, 
                                                                self.view.bounds.size.width,
                                                                self.view.bounds.size.height - ACTION_PANE_HEIGHT)
                    ];

	
	NSString* entryContextToShow = [NSString stringWithFormat:@"<html><center>%@</center></html>", self.entry.entryContext];
    [self.webView loadHTMLString:entryContextToShow baseURL:nil];   
    
	self.webView.delegate = self;
    [self.view addSubview: self.webView];

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
    
    [self.socializeActionPanel updateCountsWithViewsCount:[NSNumber numberWithInt:self.entry.socializeEntry.views]
                                           withLikesCount:[NSNumber numberWithInt:self.entry.socializeEntry.likes] 
                                                  isLiked: NO 
                                        withCommentsCount:[NSNumber numberWithInt:self.entry.socializeEntry.comments]
     ];
    
    [self.view addSubview:self.socializeActionPanel];
        
    [self.socializeActionPanel setNeedsDisplay];       
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - SocializeActionViewDelegate

-(void)commentButtonTouched:(id)sender
{
    
}

-(void)likeButtonTouched:(id)sender
{
    
}

-(void)shareButtonTouched:(id)sender
{
    
}

@end
