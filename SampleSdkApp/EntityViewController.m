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

#define ACTION_PANE_HEIGHT 44

@interface EntityViewController() 
    -(void) initSocialize;
    -(void) showCommentsController;
    -(void) hideCommentsController;
    -(void) destroyCommentController;

    @property (nonatomic, retain) SocializeActionView* socializeActionPanel;
    @property (nonatomic, retain) UIWebView* webView;
    @property (nonatomic, retain) DemoEntry* entry;
@end

@implementation EntityViewController

@synthesize socializeActionPanel = _socializeActionPanel;
@synthesize webView = _webView;
@synthesize entry = _entry;

-(id) initWithEntry: (DemoEntry*) entry andService: (Socialize*) service
{
    self = [super init];
    if(self != nil)
    {
        self.entry = entry;
        _service = service;
        _service.entityService.delegate = self;
        _service.likeService.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [_socializeActionPanel release]; _socializeActionPanel = nil;
    [_commentsNavigationController release];  _commentsNavigationController = nil;
    [_webView release]; _webView = nil;
    [_entry release]; _entry = nil;
    _service = nil;
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
    
//	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//	self.view.autoresizesSubviews = YES;
//	self.view.backgroundColor = [UIColor whiteColor];
    
//    UIWebView* webView = [[UIWebView alloc] initWithFrame: CGRectMake(0,
//                                                                0, 
//                                                                self.view.bounds.size.width,
//                                                                self.view.bounds.size.height)
//                    ];

//    UIWebView* webView = [[UIWebView alloc] initWithFrame: self.view.bounds];
//                          
//    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
//    self.webView = webView;
//    [webView release]; webView = nil;
//	
//	NSString* entryContextToShow = [NSString stringWithFormat:@"<html><center>%@</center></html>", self.entry.entryContext];
//    [self.webView loadHTMLString:entryContextToShow baseURL:nil];   
//    
//	self.webView.delegate = self;
//    [self.view addSubview: self.webView];

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
    CGRect size = self.view.bounds;
    
//    SocializeActionView* socializeActionPanel = [[SocializeActionView alloc] initWithFrame:
//                                 CGRectMake(0,
//                                            self.view.bounds.size.height - ACTION_PANE_HEIGHT, 
//                                            self.view.bounds.size.width,
//                                            ACTION_PANE_HEIGHT)
//                                 ];
    SocializeActionView* socializeActionPanel = [[SocializeActionView alloc] initWithFrame:
                                                 CGRectMake(0,
                                                            size.size.height - ACTION_PANE_HEIGHT, 
                                                            size.size.width,
                                                            ACTION_PANE_HEIGHT)];
                                                 
    self.socializeActionPanel = socializeActionPanel;
    [socializeActionPanel release]; socializeActionPanel = nil;
    
    self.socializeActionPanel.opaque = NO;
    self.socializeActionPanel.alpha = 0.9;
    //self.socializeActionPanel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    
    self.socializeActionPanel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);    self.socializeActionPanel.autoresizesSubviews = YES;
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [keyField resignFirstResponder];
    [nameField resignFirstResponder];
    [resultsView resignFirstResponder];
}
#pragma mark - SocializeActionViewDelegate

-(void)commentButtonTouched:(id)sender
{
    [self showCommentsController];
}   

-(void)likeButtonTouched:(id)sender
{
    if (_entity){
        if (!self.socializeActionPanel.isLiked)
            [_service.likeService postLikeForEntity:_entity];
        else if (_myLike){
            [_service.likeService deleteLike:_myLike];
        }
    }
}

-(void)shareButtonTouched:(id)sender
{
    [_service.entityService createEntityWithKey:keyField.text andName:nameField.text];
}

-(IBAction)createNew:(id)button
{
    [_service.entityService createEntityWithKey:keyField.text andName:nameField.text];
    [self touchesEnded:nil withEvent:nil];
}

-(IBAction)getLikes:(id)button
{
    [_service.likeService getLikesForEntityKey:keyField.text];
    [self touchesEnded:nil withEvent:nil];
}

#pragma mark - show comments controller

-(void)showCommentsController
{
	CommentsViewController* commentsController = [[CommentsViewController alloc] 
                          initWithNibName:@"CommentsViewController"
                          bundle:nil];
	
    commentsController.title = @"Comments";
    commentsController.entityKey = _entry.socializeEntry.key;
    commentsController.commentService = _service.commentService;
    
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

//-(void)prepare{
//	//[commentsController startFetchingComments];
//}
-(void) entityService:(SocializeEntityService *)entityService didReceiveListOfEntities:(NSArray *)entityList
{
    _entity = (id<SocializeEntity>)[entityList lastObject];
    
    [_entity retain];
    
    resultsView.text = [NSString stringWithFormat:@"%@\n%key=%@, name=%@", resultsView.text, _entity.key, _entity.name];
}

-(void) entityService:(SocializeEntityService *)entityService didFailWithError:(NSError *)error
{
   resultsView.text = @"Error";
}

-(void) entityService:(SocializeEntityService *)entityService didReceiveEntity:(id<SocializeEntity>)entityObject
{
    resultsView.text = [NSString stringWithFormat:@"%@\n%key=%i, name=%i", resultsView.text, entityObject.key, entityObject.name];
}

#pragma mark like service delegate
-(void)didFailService:(id)service error:(NSError*)error{
    DLog(@"like error %@", error);
}

-(void)didPostLike:(id)service like:(id)data{
    if (data != nil){
        NSArray* likes = data;
        _myLike = [likes objectAtIndex:0];
        [_myLike retain];
        if (_myLike != nil)
            [self.socializeActionPanel updateLikesCount:[NSNumber numberWithFloat:[_myLike.entity likes]]  liked:YES]; 
    }
}

-(void)didDeleteLike:(id)service like:(id)data{
    [self.socializeActionPanel updateIsLiked:NO];
    [_myLike release]; _myLike = nil;
}

-(void)didFetchLike:(id)service like:(id)data{
    
    NSArray* dataFetced = data; 
    NSString *tmpString = [NSString string];
    for (id<SocializeLike> like in dataFetced){
        NSString* newString = [NSString stringWithFormat:@"\n %@ Like By user %@", [[like user] userName] ] ;
        tmpString = [tmpString stringByAppendingString:newString];
    }
    
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Like Results"];
	[alert setMessage:tmpString];
	[alert setDelegate:self];
	[alert show];
	[alert release];
}

#pragma mark -

-(void)destroyCommentController
{
    [_commentsNavigationController.view removeFromSuperview];    
    [_commentsNavigationController release];  _commentsNavigationController = nil;
}

@end
