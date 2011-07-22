//
//  EntryViewController.m
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "EntityViewController.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeLike.h"
#import "SocializeEntity.h"
#import "LikeListViewController.h"


#define ACTION_PANE_HEIGHT 44

@interface EntityViewController() 
-(void) initActionViews;
-(void) showCommentsController;
-(void) hideCommentsController;

@property (nonatomic, retain) SocializeActionView* socializeActionPanel;
@property (nonatomic, retain) UIWebView*           webView;
@property (nonatomic, assign) Socialize*           service;

@end

@implementation EntityViewController

@synthesize socializeActionPanel = _socializeActionPanel;
@synthesize webView = _webView;
@synthesize entity = _entity;
@synthesize service = _service;

-(id) initWithEntry: (id<SocializeEntity>) entity andService: (Socialize*) service
{
    self = [super init];
    if(self != nil)
    {
        self.entity = entity;
        self.service = service;
    }
    return self;
}

- (void)dealloc
{
    [_socializeActionPanel release]; _socializeActionPanel = nil;
    [_commentsNavigationController release];  _commentsNavigationController = nil;
    [_webView release]; _webView = nil;
    self.service = nil;
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

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.autoresizesSubviews = YES;
	self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect size = self.view.frame;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame: CGRectMake(0,
                                                                0, 
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height)
                    ];
    
    size = self.view.frame;

    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
    self.webView = webView;
    [webView release]; webView = nil;
	
	NSString* entryContextToShow = [NSString stringWithFormat:@"<html><center>%@</center></html>"];
    [self.webView loadHTMLString:entryContextToShow baseURL:nil];   
    
	self.webView.delegate = self;
    [self.view addSubview: self.webView];
    [_webView loadHTMLString:@"<body> <h2> The entity is the unit around which Socialize revolves</h2> <Br>An entity is always upon a URL, which can have assocated views(see bottom left count and which can have likes and comments (see bottom right buttons/counters)) </body> " baseURL:nil];

	//initialize socialize related classes
	[self initActionViews];   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    self.socializeActionPanel = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_service setDelegate:self];
    [_service getEntityByKey:_entity.key];

    [self.service viewEntity:_entity];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void) initActionViews {
    SocializeActionView* socializeActionPanel = [[SocializeActionView alloc] initWithFrame:
                                 CGRectMake(0,
                                            self.view.bounds.size.height - ACTION_PANE_HEIGHT, 
                                            self.view.bounds.size.width,
                                            ACTION_PANE_HEIGHT)
                                 ];
                                                 
    self.socializeActionPanel = socializeActionPanel;
    [socializeActionPanel release]; socializeActionPanel = nil;
    
    self.socializeActionPanel.opaque = NO;
    self.socializeActionPanel.alpha = 0.9;
    self.socializeActionPanel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);    
    self.socializeActionPanel.autoresizesSubviews = YES;
    self.socializeActionPanel.delegate = self;
    [self.socializeActionPanel updateCountsWithViewsCount:[NSNumber numberWithInt:self.entity.views]
                                           withLikesCount:[NSNumber numberWithInt:self.entity.likes] 
                                                  isLiked: NO 
                                        withCommentsCount:[NSNumber numberWithInt:self.entity.comments]
     ];
    
    [self.view addSubview:self.socializeActionPanel];
    [self.socializeActionPanel setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return NO;
}


#pragma mark - SocializeActionViewDelegate

-(void)commentButtonTouched:(id)sender {
    [self showCommentsController];
}   

-(void)likeButtonTouched:(id)sender {
    if([_socializeActionPanel isLiked]) 
       [_service unlikeEntity:_myLike]; 
    else 
       [_service likeEntityWithKey:self.entity.key longitude:nil latitude:nil];
}

-(void)likeListButtonTouched:(id)sender {
    LikeListViewController* controller = [[[LikeListViewController alloc] initWithNibName:@"LikeListViewController" bundle:nil andService:_service andEntityKey:self.entity.key] autorelease];
    [[self navigationController] pushViewController:controller animated:YES];
}

#pragma mark - show comments controller

-(void)showCommentsController
{
	CommentsViewController* commentsController = [[CommentsViewController alloc] 
                          initWithNibName:@"CommentsViewController"
                          bundle:nil];
	
    commentsController.title = @"Comments";
    commentsController.entityKey = self.entity.key;
    commentsController.service = _service;
    
	UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    CGSize buttonSize = [cancelButton.titleLabel.text sizeWithFont:cancelButton.titleLabel.font constrainedToSize:CGSizeMake(100, 29)];
    cancelButton.bounds = CGRectMake(0, 0, buttonSize.width+20, 29);
    
    [cancelButton addTarget:self action:@selector(hideCommentsController) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem * rightCloseItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
	commentsController.navigationItem.rightBarButtonItem = rightCloseItem;	
	[rightCloseItem release];
   
    _commentsNavigationController = [[UINavigationController alloc] 
                                    initWithRootViewController:commentsController];

    [commentsController release]; commentsController = nil;
    
    _commentsNavigationController.wantsFullScreenLayout = YES;
    
    CGRect windowFrame = self.view.window.frame;
    CGRect navFrame = CGRectMake(0, windowFrame.size.height, windowFrame.size.width, windowFrame.size.height);
    _commentsNavigationController.view.frame = navFrame;
    _commentsNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _commentsNavigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self.view.window addSubview:_commentsNavigationController.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(prepare)];
    [UIView setAnimationDuration:0.4];
    _commentsNavigationController.view.frame = CGRectMake(0, 0, navFrame.size.width, navFrame.size.height);
    [UIView commitAnimations];
 
}

-(void)hideCommentsController
{
	CGRect windowFrame = self.view.window.frame;
	CGRect navFrame = CGRectMake(0, windowFrame.size.height, windowFrame.size.width, windowFrame.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(destroyCommentController)];
	[UIView setAnimationDuration:0.4];
	_commentsNavigationController.view.frame = navFrame;
	[UIView commitAnimations];
}

#pragma mark - Socialize Service delegate

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{

    DLog(@"didCreate %@", object);
    if ([object conformsToProtocol:@protocol(SocializeLike)]){
        _myLike = (id<SocializeLike>)object;
        [_myLike retain];
        if (_myLike != nil)
            [self.socializeActionPanel updateLikesCount:[NSNumber numberWithFloat:[_myLike.entity likes]]  liked:YES];
    }
    else if ([object conformsToProtocol:@protocol(SocializeView)]){
        id <SocializeView> _myView = (id<SocializeView>)object;
        if (_myView != nil){
            [self.socializeActionPanel updateViewsCount:[NSNumber numberWithFloat:[_myView.entity views]]];
        }
    }
}

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    DLog(@"didDelete %@", object);
    [self.socializeActionPanel updateIsLiked:NO];
    [_myLike release]; _myLike = nil;
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    DLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    DLog(@"didFail %@", error);
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{

    id <SocializeObject> socializeObject = (id<SocializeObject>)[dataArray objectAtIndex:0];
    
    if ([socializeObject conformsToProtocol:@protocol(SocializeEntity)]) {
        id<SocializeEntity> entity = (id<SocializeEntity>)socializeObject;
        [self.socializeActionPanel updateCommentsCount:[NSNumber numberWithInt:entity.comments] ];
        [self.socializeActionPanel updateLikesCount:[NSNumber numberWithInt:entity.likes] liked:NO ];
        [self.socializeActionPanel updateViewsCount:[NSNumber numberWithInt:entity.views]];
    }
}

@end
