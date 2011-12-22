//
//  AuthorizeViewController.m
//  appbuildr
//
//  Created by Fawad Haider  on 5/17/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeAuthViewController.h"
#import "SocializeAuthenticateService.h"
#import "UIButton+Socialize.h"
#import "UINavigationBarBackground.h"
#import "SocializeAuthTableViewCell.h"
#import "SocializeUser.h"
#import "SocializeAuthInfoTableViewCell.h"

@interface  SocializeAuthViewController()
    -(SocializeAuthTableViewCell *)getAuthorizeTableViewCell;
    -(SocializeAuthInfoTableViewCell*)getAuthorizeInfoTableViewCell;
    -(void)profileViewDidFinish;
    -(id)getCellFromNibNamed:(NSString * )nibNamed withClass:(Class)klass;
    -(NSArray *) getTopLevelViewsFromNib:(NSString *)nibName;
    @property (nonatomic, retain) id<SocializeAuthViewControllerDelegate> delegate;
    @property (nonatomic, retain) id<SocializeUser> user;
@end


CGFloat SocializeAuthTableViewRowHeight = 56;

@implementation SocializeAuthViewController



@synthesize tableView;
@synthesize skipButton = skipButton_;
@synthesize delegate = _delegate;
@synthesize user = _user;


-(void) dealloc {
    self.tableView = nil;
    self.delegate = nil;
    self.user = nil;
    [super dealloc];
}
+(UINavigationController*)authViewControllerInNavigationController:(id<SocializeAuthViewControllerDelegate>)delegate;
{
    SocializeAuthViewController *authController 
    = [[[SocializeAuthViewController alloc] initWithDelegate:delegate] autorelease];
                                                                                                              
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:authController] autorelease];
    UIImage *navBarImage = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    [navController.navigationBar setBackgroundImage:navBarImage];
    return navController;
}
- (id)initWithDelegate:(id<SocializeAuthViewControllerDelegate>)delegate {
    if( self = [super initWithNibName:@"SocializeAuthViewController" bundle:nil] ) {
        self.delegate = delegate;
        self.title = @"Authenticate";
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SocializeAuthViewControllerNumSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SocializeAuthTableViewRowHeight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.rightBarButtonItem = [self createSkipButton];
    self.view.backgroundColor = [UIColor colorWithRed:50/255.0f green:58/255.0f blue:67/255.0f alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:25/255.0f green:31/255.0f blue:37/255.0f alpha:1.0];
}
-(IBAction)skipButtonPressed:(id)sender {
    if( [self.delegate respondsToSelector:@selector(authorizationSkipped)] ) {
        [self.delegate authorizationSkipped];
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // return 1;
    NSInteger noOfRows = 0;
	switch (section) 
	{
		case SocializeAuthViewControllerSectionAuthTypes:
            noOfRows = 1;
            break;
        case SocializeAuthViewControllerSectionAuthInfo:
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
        cell = [self getCellFromNibNamed:@"SocializeAuthInfoTableViewCell" withClass:[SocializeAuthInfoTableViewCell class]];
	}
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(id)getCellFromNibNamed:(NSString * )nibNamed withClass:(Class)klass 
{
    id cell = nil;
    NSArray *topLevelViews = [self getTopLevelViewsFromNib:nibNamed];
    for (id topLevelView in topLevelViews) {
        if ([topLevelView isKindOfClass:klass] ) {
            cell = topLevelView;
        }
    }
    return cell;
}

-(NSArray *) getTopLevelViewsFromNib:(NSString *)nibName {
    return [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
}
    
- (void)profileEditViewControllerDidCancel:(SocializeProfileEditViewController *)profileEditViewController {
    [self profileViewDidFinish];        
}

- (void)profileEditViewController:(SocializeProfileEditViewController *)profileEditViewController didUpdateProfileWithUser:(id<SocializeFullUser>)user {
    [self profileViewDidFinish];            
}

- (void)profileViewDidFinish {
    SEL didAuthSelector = @selector(socializeAuthViewController:didAuthenticate:);
    if ([self.delegate respondsToSelector:didAuthSelector] ) {
        [self.delegate socializeAuthViewController:self didAuthenticate:self.user];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)didAuthenticate:(id<SocializeUser>)user 
{
    self.user = user;
    if ( [self.socialize isAuthenticatedWithFacebook] ) { 
        SocializeProfileEditViewController *profileEdit = [SocializeProfileEditViewController profileEditViewController];
        profileEdit.delegate = self;
        [self.navigationController pushViewController:profileEdit animated:YES];
    }
}

-(SocializeAuthTableViewCell *)getAuthorizeTableViewCell
{
	static NSString *profileCellIdentifier = @"authorize_cell";
	SocializeAuthTableViewCell *cell =(SocializeAuthTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
	if (cell == nil) 
	{
        cell = [self getCellFromNibNamed:@"SocializeAuthTableViewCell" withClass:[SocializeAuthTableViewCell class]];
	}
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
	if(indexPath.section == SocializeAuthViewControllerSectionAuthTypes){
        [self.socialize authenticateWithFacebook];
        [self startLoadAnimationForView:self.view];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    SocializeAuthTableViewCell* authCell = nil;
    SocializeAuthInfoTableViewCell* infoCell = nil;
	
	switch (indexPath.section)  
	{
		case SocializeAuthViewControllerSectionAuthTypes:
			authCell = [self getAuthorizeTableViewCell];
			authCell.backgroundColor = [UIColor colorWithRed:61/255.0f green:70/255.0f blue:76/255.0f alpha:1.0] ;

            
            switch( indexPath.row ) 
            {
                case SocializeAuthViewControllerRowFacebook:
                    authCell.cellIcon.image = [UIImage imageNamed:@"socialize-authorize-facebook-enabled-icon.png"];
                    authCell.cellLabel.text = @"facebook";
                    break;
                case SocializeAuthViewControllerRowTwitter:
                    authCell.cellIcon.image = [UIImage imageNamed:@"socialize-authorize-twitter-disabled-icon.png"];
                    authCell.cellLabel.text = @"Twitter";
                    break;
            }
            authCell.cellAccessoryIcon.image = [UIImage imageNamed:@"socialize-activity-call-out-arrow.png"];
            cell = authCell;
            break;
			
		case SocializeAuthViewControllerSectionAuthInfo:
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
