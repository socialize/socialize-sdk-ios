/*
 * TestActivityViewController.m
 * SocializeSDK
 *
 * Created on 10/19/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "TestActivityViewController.h"


@implementation TestActivityViewController
@synthesize activityTable = _activityTable;
@synthesize activityType = _activityType;
@synthesize activity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        socialize = [[Socialize alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [_activityTable release];
    [activity release];
    [_activityType release];
    [socialize release];
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
    self.activityType.enabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.activityTable = nil;
    self.activityType = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [activity count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", [[self.activity objectAtIndex:indexPath.row] objectID]];
    return cell;
}

-(void)service:(SocializeService *)service didFail:(NSError *)error
{
    [_loadingView removeView];
    self.activity = [NSArray array];
    [self.activityTable reloadData];
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"Could not get activity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

-(void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray
{
    [_loadingView removeView];
    
    self.activity = dataArray;
    [self.activityTable reloadData];
}

-(IBAction)getActivityBtnTouch
{
     _loadingView = [SocializeLoadingView loadingViewInView:self.view]; 
//    [socialize getActivityOfCurrentApplication];
    
    [socialize getActivityOfUser: socialize.authenticatedUser];
}

@end
