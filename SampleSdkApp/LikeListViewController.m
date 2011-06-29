//
//  LikeListViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 6/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "LikeListViewController.h"


@implementation LikeListViewController


@synthesize  tableView = _tableView, service = _service;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andService: (Socialize*) service andEntityKey:(NSString*)entityKey
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _entityKey = [entityKey retain];
        self.service = service;
        self.service.likeService.delegate = self;
//        _likes = [[NSMutableArray alloc] initWithCapacity:10];
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
    
    [_service.likeService getLikesForEntityKey:_entityKey];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    
    cell.textLabel.text = [[_likes objectAtIndex:indexPath.row] name];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
/*    DemoEntity* demoEntity = [[DemoEntity alloc] initWithSocializeEntry:[_entities objectAtIndex:indexPath.row] entryContext:@"Demo entity text"];
    EntityViewController* entityController = [[EntityViewController alloc] initWithEntry:demoEntity andService:_service];
    [self.navigationController pushViewController:entityController animated:YES];
    
    [demoEntity release];
 */
}

#pragma mark Socialize Like delegate

-(void)didPostLike:(id)service like:(id)data{
    
}

-(void)didDeleteLike:(id)service like:(id)data{
    
}

-(void)didFetchLike:(id)service like:(id)data{
    _likes = [data retain];
}

-(void)didFailService:(id)service error:(NSError*)error{
    
}

#pragma mark -
@end
