//
//  LikeListViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "LikeListViewController.h"
#import <Socialize/Socialize.h>
#import "UIButton+Socialize.h"
@implementation LikeListViewController


@synthesize  tableView = _tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _socialize = [[Socialize alloc] initWithDelegate:self];
        self.title = @"Users Liking the entity";
    }
    return self;
}

- (void)dealloc
{
    _tableView.delegate = nil;
    [_tableView release];
    [_likes release];
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

    self.view.backgroundColor = [UIColor lightGrayColor];
    [getLikesButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];
    
    
    // Do any additional setup after loading the view from its nib.
    _tableView.backgroundColor = [UIColor lightGrayColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    hiddenButton = [[UIButton alloc] init]; 
    hiddenButton.hidden = YES;
    hiddenButton.accessibilityLabel = @"hiddenButton";

}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // [self.service setDelegate:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [_likes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    id<SocializeLike> like = [_likes objectAtIndex:indexPath.row];
    cell.textLabel.text = [[like user] userName];

    return cell;
}

#pragma mark IB actions
-(IBAction)getLikes{
    
    if (!hiddenButton){
        hiddenButton = [[UIButton alloc] init]; 
        hiddenButton.hidden = YES;
        hiddenButton.accessibilityLabel = @"hiddenButton";
        [self.view addSubview:hiddenButton];
    }
    
    _loadingView = [SocializeLoadingView loadingViewInView:self.view]; 
    [_socialize getLikesForEntityKey:entityField.text first:nil last:nil];
}
#pragma mark -

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark Socialize Like delegate

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{

}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{

}

-(void)service:(SocializeService*)service didFail:(NSError*)error{

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;

    [_loadingView removeView]; 
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"cannot get likes" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];

}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;
    
    [entityField resignFirstResponder];
    
    [_loadingView removeView]; 
    _likes = [dataArray retain];
    [self.tableView reloadData];
}
#pragma mark -

@end
