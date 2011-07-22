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
@synthesize service = _service;
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
    _service = [[Socialize alloc] initWithDelegate:self]; 
    [_service getCommentList:_entityKey first:[NSNumber numberWithInt:1] last:[NSNumber numberWithInt:4]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_service release]; _service = nil;
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

#pragma  mark   - Socialize service delegate

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    DLog(@"didCreate %@", object);
    [_comments addObject:object];
    [_commentsTable reloadData];
}

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    DLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    DLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFetch:(id<SocializeObject>)object{
    DLog(@"didFetch %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    DLog(@"didFail %@", error);
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    DLog(@"didFetchElements %@", dataArray);
    if ([dataArray count]){
        id<SocializeObject> object = [dataArray objectAtIndex:0];
        if ([object conformsToProtocol:@protocol(SocializeComment) ]){
            [_comments addObjectsFromArray:dataArray];
            [_commentsTable reloadData]; 
        }
    }
}
@end
