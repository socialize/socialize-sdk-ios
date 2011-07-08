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
        _comments = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)dealloc
{
    [_commentText release]; _commentText = nil;
    [_sendButton release]; _sendButton = nil;
    [_commentsTable release]; _commentsTable = nil;
    [_comments release]; _comments = nil;
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
    
    [_service createCommentForEntityWithKey:_entityKey comment:_commentText.text];
    _commentText.text = @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[_comments objectAtIndex:indexPath.row] text];
    
    return cell;
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
    [_comments addObject:comment];
    [_commentsTable reloadData];
}

-(void) receivedComments: (SocializeCommentsService*)service comments: (NSArray*) comments
{
    [_comments addObjectsFromArray:comments];
    [_commentsTable reloadData];    
}

-(void) didFailService:(SocializeCommentsService*)service withError: (NSError *)error
{
    NSLog(@"%@", error);
}


-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    NSLog(@"didCreate %@", object);
}

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    NSLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    NSLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFetch:(id<SocializeObject>)object{
    NSLog(@"didFetch %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"didFail %@", error);
}

-(void)service:(SocializeService*)service didCreateWithElements:(NSArray*)dataArray andErrorList:(id)errorList{
    NSLog(@"didCreateWithElements %@", dataArray);
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray andErrorList:(id)errorList{
    NSLog(@"didFetchElements %@", dataArray);
}


@end
