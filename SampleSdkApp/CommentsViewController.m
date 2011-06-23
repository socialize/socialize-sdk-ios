//
//  CommentsViewController.m
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/6/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "CommentsViewController.h"


@implementation CommentsViewController

@synthesize commentText = _commentText;
@synthesize sendButton = _sendButton;
@synthesize commentsTable = _commentsTable;
@synthesize commentService = _service;
@synthesize entityKey = _entityKey;

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
    [_commentText release]; _commentText = nil;
    [_sendButton release]; _sendButton = nil;
    [_commentsTable release]; _commentsTable = nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _service.delegate = self;
    [_service getCommentList:_entityKey];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _service.delegate = nil;
    self.commentsTable = nil;
    self.sendButton = nil;
    self.commentText = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - Button

-(IBAction) sendBtnPressed: (id) sender
{
    [_commentText resignFirstResponder];
    
    // add send code here
    //
    _commentText.text = @"";
    [_commentsTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
	UITouch *touch = [[event allTouches] anyObject];
	if ( ([touch view] != _commentText) && [_commentText isFirstResponder]){
		[_commentText resignFirstResponder];
	}
	[super touchesBegan:touches withEvent:event];
}

#pragma  mark   - Socialize comment service

-(void) receivedComment: (SocializeCommentsService*)service comment: (id<SocializeComment>) comment
{
    //TODO:: save response
    [_commentsTable reloadData];
}

-(void) receivedComments: (SocializeCommentsService*)service comments: (NSArray*) comments
{
    //TODO:: save response
    [_commentsTable reloadData];    
}

-(void) didFailService:(SocializeCommentsService*)service withError: (NSError *)error
{
    NSLog(@"%@", error);
}

@end
