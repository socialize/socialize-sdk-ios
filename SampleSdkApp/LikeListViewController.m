//
//  LikeListViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "LikeListViewController.h"
#import "SocializeLike.h"

@implementation LikeListViewController


@synthesize  tableView = _tableView, service = _service;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andService: (Socialize*) service andEntityKey:(NSString*)entityKey
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _entityKey = [entityKey retain];
        self.service = service;
        self.title = @"Users Liking the url";
    }
    return self;
}

- (void)dealloc
{
    [_entityKey release];
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
    
    // Do any additional setup after loading the view from its nib.
    _tableView.dataSource = self;
    _tableView.delegate = self;
     
    [self.service setDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.service setDelegate:self];
    [_service getLikesForEntityKey:_entityKey first:[NSNumber numberWithInt:1] last:[NSNumber numberWithInt:10]];
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
    DLog(@"SocializeLike user name %@", [[like user] userName]);
    cell.textLabel.text = [[like user] userName];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark Socialize Like delegate

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    DLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    DLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    DLog(@"didFail %@", error);
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    DLog(@"didFetchElements %@", dataArray);
    _likes = [dataArray retain];
    [self.tableView reloadData];
}

@end
