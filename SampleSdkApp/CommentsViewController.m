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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - Button

-(IBAction) sendBtnPressed: (id) sender
{
    
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

@end
