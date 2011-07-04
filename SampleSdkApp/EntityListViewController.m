/*
 * EntityListViewController.m
 * SocializeSDK
 *
 * Created on 6/29/11.
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

#import "EntityListViewController.h"
#import "EntityViewController.h"
#import "UserProfileViewController.h"

@interface EntityListViewController()
    -(void) addNewEntity;
    -(void) showProfileInfo;
@end

@implementation EntityListViewController

@synthesize service = _service;

#pragma mark - Socialize Entity Service Delegate

-(void) entityService:(SocializeEntityService *)entityService didReceiveEntity:(id<SocializeEntity>)entityObject
{
    [_entities addObject:entityObject];
    [self.tableView reloadData];
}

-(void) entityService:(SocializeEntityService *)entityService didReceiveListOfEntities:(NSArray *)entityList
{
    [_entities addObjectsFromArray:entityList];
    [self.tableView reloadData];
}

-(void) entityService:(SocializeEntityService *)entityService didFailWithError:(NSError *)error
{
    NSLog(@"Failed with error -- %@", error);
}


#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) //enter pressed 
    {
        [_service.entityService createEntityWithKey:_entityKey.text andName:_entityName.text];
    }
    
    _entityKey.text = @"";
    _entityName.text = @"";
}

#pragma mark -

-(void) addNewEntity
{    
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Entity key and name" 
                                                     message:@"\n\n\n" // IMPORTANT
                                                    delegate:self 
                                           cancelButtonTitle:@"Cancel" 
                                           otherButtonTitles:@"Enter", nil];
    
    [prompt addSubview:_entityKey];
    [prompt addSubview:_entityName];
    
    
    [prompt show];
    [prompt release];
    
    // set cursor and show keyboard
    [_entityKey becomeFirstResponder];
}

-(void) showProfileInfo
{
    UserProfileViewController* userViewContorller = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];

    [self presentModalViewController:userViewContorller animated:YES];
    
    [userViewContorller release]; userViewContorller = nil;
}

- (id)initWithStyle:(UITableViewStyle)style andService: (Socialize*) service
{
    self = [super initWithStyle:style];
    if (self) {
        self.service = service;
        self.service.entityService.delegate = self;
        _entities = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)dealloc
{
    self.service = nil;
    [_entities release]; _entities = nil;
    [_entityKey release]; _entityKey = nil;
    [_entityName release]; _entityName = nil;
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
    
    self.title = @"Entities";
    
    UIBarButtonItem* addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewEntity)];
    
    self.navigationItem.rightBarButtonItem = addBtn;
    [addBtn release]; addBtn = nil;
    
    UIBarButtonItem* profileBtn = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStyleBordered target:self action:@selector(showProfileInfo)];

    self.navigationItem.leftBarButtonItem = profileBtn;
    [profileBtn release]; profileBtn = nil;
    
    _entityKey = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
    [_entityKey setBackgroundColor:[UIColor whiteColor]];
    [_entityKey setPlaceholder:@"key"];
    
    _entityName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)]; 
    [_entityName setBackgroundColor:[UIColor whiteColor]];
    [_entityName setPlaceholder:@"name"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    return [_entities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[_entities objectAtIndex:indexPath.row] name];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoEntity* demoEntity = [[DemoEntity alloc] initWithSocializeEntry:[_entities objectAtIndex:indexPath.row] entryContext:@"Demo entity text"];
    EntityViewController* entityController = [[EntityViewController alloc] initWithEntry:demoEntity andService:_service];
    [self.navigationController pushViewController:entityController animated:YES];
    
    [demoEntity release];
}

@end
