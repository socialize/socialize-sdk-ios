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
///#import "SocializeObject.h"
#import "SocializeEntity.h"

@interface EntityListViewController()
//-(void) addNewEntity;
///-(void) showSettingsInfo;
-(void)loadEntities;
@end

@implementation EntityListViewController

@synthesize service = _service;

#pragma mark - UIAlertView delegate

-(void)loadEntities{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"urls" ofType:@"plist"];
    
    NSLog(@"path %@", path);
    
    // Build the array from the plist  
    NSMutableDictionary *myDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"myDic %@", myDic);

    NSMutableArray *array2 = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
    NSLog(@"array2 %@", array2);
    SocializeEntity* entity;
    for (NSString* mstring in [myDic allValues]){
        entity = [self.service createObjectForProtocol:@protocol(SocializeEntity)]; 
        entity.key = mstring;
        entity.name = mstring;
        [_entities addObject:entity];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && _entityKey.text != @"" /*&& _entityName.text != @""*/){
        [_service getEntityByKey:_entityKey.text];
    }
    
    _entityKey.text = @"";
    _entityName.text = @"";
}

#pragma mark -

-(void) fetchEntity
{    
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Get Entity" 
                                                     message:@"\n\n\n" // IMPORTANT
                                                    delegate:self 
                                           cancelButtonTitle:@"Cancel" 
                                           otherButtonTitles:@"Enter", nil];
    
    [prompt addSubview:_entityKey];
    
    [prompt show];
    [prompt release];
    
    // set cursor and show keyboard
    [_entityKey becomeFirstResponder];
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
    
    UIBarButtonItem* addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(fetchEntity)];
    
    self.navigationItem.rightBarButtonItem = addBtn;
    [addBtn release]; addBtn = nil;
    
/*    UIBarButtonItem* settingsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSettingsInfo)];

    self.navigationItem.leftBarButtonItem = settingsBtn;
    [settingsBtn release]; settingsBtn = nil;
*/
    
    _entityKey = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
    [_entityKey setBackgroundColor:[UIColor whiteColor]];
    [_entityKey setPlaceholder:@"key"];
    _entityKey.text = @"";
    
    _entityName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)]; 
    [_entityName setBackgroundColor:[UIColor whiteColor]];
    [_entityName setPlaceholder:@"name"];
    _entityName.text = @"";
    
    [self loadEntities];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.service setDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.service setDelegate:self];
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
    EntityViewController* entityController = [[EntityViewController alloc] initWithEntry:[_entities objectAtIndex:indexPath.row] andService:_service];
    [self.navigationController pushViewController:entityController animated:YES];
}

#pragma mark - Service delegete

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    [_entities addObject:object];
    [self.tableView reloadData];
}

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    DLog(@"didDelete %@", object);
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    DLog(@"didUpdate %@", object);
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    DLog(@"didFail %@", error);
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Entity Not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    DLog(@"didFetchElements %@", dataArray);
    id <SocializeObject> socializeObject = (id<SocializeObject>)[dataArray objectAtIndex:0];
    
    if ([socializeObject conformsToProtocol:@protocol(SocializeEntity)]) {
        EntityViewController* entityController = [[EntityViewController alloc] initWithEntry:(id<SocializeEntity>)socializeObject andService:_service];
        [self.navigationController pushViewController:entityController animated:YES];
    }
}
@end
