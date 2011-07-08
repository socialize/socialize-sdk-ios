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
#import "SettingsViewController.h"


@interface EntityListViewController()
    -(void) addNewEntity;
    -(void) showSettingsInfo;
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
    if(buttonIndex == 1 && _entityKey.text != @"" && _entityName.text != @"") //enter pressed 
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

-(void) showSettingsInfo
{
    SettingsViewController* settingsViewController = [[SettingsViewController alloc] initWithService:self.service];
    UINavigationController* settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    [self presentModalViewController:settingsNavController animated:YES];
    
    [settingsNavController release]; settingsNavController = nil;
    [settingsViewController release]; settingsViewController = nil;
}

- (id)initWithStyle:(UITableViewStyle)style andService: (Socialize*) service
{
    self = [super initWithStyle:style];
    if (self) {
        self.service = service;
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
    
    UIBarButtonItem* settingsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSettingsInfo)];

    self.navigationItem.leftBarButtonItem = settingsBtn;
    [settingsBtn release]; settingsBtn = nil;
    
    _entityKey = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
    [_entityKey setBackgroundColor:[UIColor whiteColor]];
    [_entityKey setPlaceholder:@"key"];
    _entityKey.text = @"";
    
    _entityName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)]; 
    [_entityName setBackgroundColor:[UIColor whiteColor]];
    [_entityName setPlaceholder:@"name"];
    _entityName.text = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.service.entityService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.service.entityService.delegate = nil;
    [super viewWillDisappear:animated];
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
#pragma mark -

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
