//
//  AuthorizeViewController.m
//  appbuildr
//
//  Created by Fawad Haider  on 5/17/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeAuthenticationViewController.h"
#import "UIButton+Socialize.h"

@interface  SocializeAuthenticationViewController(private)
-(SocializeAuthTableViewCell *)getAuthorizeTableViewCell;
-(SocializeAuthInfoTableViewCell*)getAuthorizeInfoTableViewCell;
@end

@implementation SocializeAuthenticationViewController

@synthesize tableView;
//@synthesize socialize;





+(UINavigationController*)createNavigationControllerForAuthViewController
{
    SocializeAuthenticationViewController *authController 
    = [[SocializeAuthenticationViewController alloc] initWithNibName:@"SocializePostCommentViewController" bundle:nil]; 
                                                                                                              
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:authController] autorelease];
    return navController;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:50/255.0f green:58/255.0f blue:67/255.0f alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:25/255.0f green:31/255.0f blue:37/255.0f alpha:1.0];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // return 1;
    NSInteger noOfRows = 0;
	switch (section) 
	{
		case 0:
            noOfRows = 1;
            break;
        case 1:
            noOfRows = 1;
            break;
    }
    return noOfRows;
}

-(SocializeAuthInfoTableViewCell *)getAuthorizeInfoTableViewCell
{
	static NSString *authorizeInfoTableViewCellId = @"authorize_info_cell";
	SocializeAuthInfoTableViewCell *cell =(SocializeAuthInfoTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:authorizeInfoTableViewCellId];
    
	if (cell == nil) 
	{
		NSArray *topLevelViews = [[NSBundle mainBundle] loadNibNamed:@"SocializeAuthInfoTableViewCell" owner:self options:nil];
		for (id topLevelView in topLevelViews) {
			if ([topLevelView isKindOfClass:[SocializeAuthInfoTableViewCell class]] ) {
                cell = topLevelView;
            }
        }
	}
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(SocializeAuthTableViewCell *)getAuthorizeTableViewCell
{
	static NSString *profileCellIdentifier = @"authorize_cell";
    
	SocializeAuthTableViewCell *cell =(SocializeAuthTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
    
	if (cell == nil) 
	{
		NSArray *topLevelViews = [[NSBundle mainBundle] loadNibNamed:@"SocializeAuthTableViewCell" owner:self options:nil];
		for (id topLevelView in topLevelViews) {
			if ([topLevelView isKindOfClass:[SocializeAuthTableViewCell class]] ) {
                cell = topLevelView ;
            }
        }
	}
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if(indexPath.section == 0){
        [self.socialize authenticateWithFacebook];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    SocializeAuthTableViewCell* authCell = nil;
    SocializeAuthInfoTableViewCell* infoCell = nil;
	
	switch (indexPath.section)  
	{
		case 0:
			authCell = [self getAuthorizeTableViewCell];
			authCell.backgroundColor = [UIColor colorWithRed:61/255.0f green:70/255.0f blue:76/255.0f alpha:1.0] ;
            
            if (indexPath.row == 0) {
                authCell.cellIcon.image = [UIImage imageNamed:@"socialize-authorize-facebook-enabled-icon.png"];
                authCell.cellLabel.text = @"facebook";
            }
            else if (indexPath.row == 1){
                authCell.cellIcon.image = [UIImage imageNamed:@"socialize-authorize-twitter-disabled-icon.png"];
                authCell.cellLabel.text = @"Twitter";
            }
            
            authCell.cellAccessoryIcon.image = [UIImage imageNamed:@"socialize-activity-call-out-arrow.png"];
            cell = authCell;
			break;
			
		case 1:
		default:
			infoCell = [self getAuthorizeInfoTableViewCell];
			infoCell.backgroundColor = [UIColor colorWithRed:41/255.0f green:48/255.0f blue:54/255.0f alpha:1.0];
            infoCell.cellIcon.image = [UIImage imageNamed:@"socialize-authorize-user-icon.png"];
            infoCell.cellLabel.text = @"You are currently anonymous.";
            infoCell.cellSubLabel.text = @"Authenticate with a service above";
            cell = infoCell;
			break;
	}
    
	return cell;
}

@end
