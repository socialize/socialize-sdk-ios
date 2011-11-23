//
//  SocializeCommentsTableViewController.m
//  appbuildr
//
//  Created by Fawad Haider on 12/2/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import "SocializeCommentsTableViewController.h"
#import "CommentsTableViewCell.h"
#import "NSDateAdditions.h"
#import "SocializeCommentDetailsViewController.h"
#import "SocializePostCommentViewController.h"
#import "UILabel-Additions.h"
#import "UIButton+Socialize.h"
#import <QuartzCore/CALayer.h>
#import "SocializeComment.h"
#import "UINavigationBarBackground.h"
#import "ImageLoader.h"
#import "UIKeyboardListener.h"
#import "SocializeLocationManager.h"
#import "SocializeAuthenticateService.h"
#import "ImagesCache.h"
#import "TableBGInfoView.h"

@interface SocializeCommentsTableViewController()
-(NSString*)getDateString:(NSDate*)date;
-(UIViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
@end

@implementation SocializeCommentsTableViewController

@synthesize tableView = _tableView;
@synthesize cache = _cache;
@synthesize arrayOfComments = _arrayOfComments;
@synthesize isLoading = _isLoading;

@synthesize brushedMetalBackground;
@synthesize backgroundView;
@synthesize roundedContainerView;
@synthesize informationView;

@synthesize noCommentsIconView;
@synthesize commentsCell;
@synthesize footerView;
@synthesize doneButton = _doneButton;
@synthesize brandingButton = _brandingButton;


+ (UIViewController*)socializeCommentsTableViewControllerForEntity:(NSString*)entityName {
    SocializeCommentsTableViewController* commentsController = [[[SocializeCommentsTableViewController alloc] initWithNibName:@"SocializeCommentsTableViewController" bundle:nil entryUrlString:entityName] autorelease];
    UIImage *navImage = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:commentsController] autorelease];
    [nav.navigationBar setBackgroundImage:navImage];
    
    return nav;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entryUrlString:(NSString*) entryUrlString {
    
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

		_errorLoading = NO;
		_isLoading = YES;


		_commentDateFormatter = [[NSDateFormatter alloc] init];
		[_commentDateFormatter setDateFormat:@"hh:mm:ss zzz"];
        
        /*Socialize inits*/
        _entity = [[self.socialize createObjectForProtocol: @protocol(SocializeEntity)]retain];
        _entity.key = entryUrlString;
        
        /* cache for the images*/
        _cache = [[ImagesCache alloc] init];
        
	}
    return self;
}

- (void)refreshCommentsList {
    [self startLoadAnimationForView:self.view];
    [self.socialize getCommentList:_entity.key first:nil last:nil]; 
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];   
    informationView.center = self.tableView.center;
    
    if ([self.socialize isAuthenticated]) {
        [self refreshCommentsList];
    }
}

- (UIBarButtonItem*)doneButton {
    if (_doneButton == nil)
    {
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:@"Close"];
        [button addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _doneButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _doneButton;
}

-(UIBarButtonItem*)brandingButton
{
    if(_brandingButton == nil)
    {
        NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"commentsNavBarLeftItemView" owner:self options:nil];
        UIView* brandingView = [ nibViews objectAtIndex: 0];
        _brandingButton = [[UIBarButtonItem alloc] initWithCustomView:brandingView];
    }
    return  _brandingButton;
}

- (void)doneButtonPressed:(id)button {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark SocializeService Delegate

-(void)service:(SocializeService *)service didFail:(NSError *)error{

    if ([service isKindOfClass:[SocializeAuthenticateService class]])
    {
        [super service:service didFail:error];
    }
    else
    {
        [self stopLoadAnimation];
        _isLoading = NO;
        [self.tableView reloadData];
        if ( ![[error localizedDescription] isEqualToString:@"Entity does not exist."] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Failed!", @"") 
                                                        message: [error localizedDescription]
                                                       delegate: nil 
                                              cancelButtonTitle: NSLocalizedString(@"OK", @"")
                                              otherButtonTitles: nil];
            [alert show];	
            [alert release];
        }
    }
}

-(void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray{
 
    _isLoading = NO;
    [_arrayOfComments release]; _arrayOfComments = nil;
    _arrayOfComments = [dataArray retain];
    [self stopLoadAnimation];
    [self.tableView reloadData];
    
}

-(void)afterAnonymouslyLoginAction
{
    [self refreshCommentsList];
}

#pragma mark -

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {   
    [super viewDidLoad];

    /*container frame inits*/
    CGRect containerFrame = CGRectMake(0, 0, 140, 140);
    TableBGInfoView * containerView = [[[TableBGInfoView alloc] initWithFrame:containerFrame bgImageName:@"socialize-nocomments-icon.png"] autorelease];
    containerView.hidden = YES;
    containerView.center = _tableView.center;
    [_tableView addSubview:containerView];
    
    informationView = containerView;
    informationView.errorLabel.text = @"No comments to show.";
    
    _tableView.scrollsToTop = YES;
    _tableView.autoresizesSubviews = YES;

	UIImage * backgroundImage = [UIImage imageNamed:@"socialize-activity-bg.png"];
	UIImageView * imageBackgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
	_tableView.backgroundView = imageBackgroundView; 
	[imageBackgroundView release];
    
    self.tableView.accessibilityLabel = @"Comments Table View";
	self.view.clipsToBounds = YES;    
   
    
    self.navigationItem.leftBarButtonItem = self.brandingButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;    
}

#pragma mark tableFooterViewDelegate

-(IBAction)addCommentButtonPressed:(id)sender 
{
    UINavigationController * pcNavController = [SocializePostCommentViewController postCommentViewControllerInNavigationControllerWithEntityURL:_entity.key];
    [self presentModalViewController:pcNavController animated:YES];
}

#pragma mark -

#pragma mark CommentViewController delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if ([_arrayOfComments count] <= 0 && !_isLoading) 
		[self addNoCommentsBackground];
	else 
		[self removeNoCommentsBackground];
	
	if (_arrayOfComments)
		return [_arrayOfComments count];
	else
		return 0;
}

-(NSString*)getDateString:(NSDate*)startdate {
	return [NSDate getTimeElapsedString:startdate]; 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_arrayOfComments count]){

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SocializeComment* entryComment = ((SocializeComment*)[_arrayOfComments objectAtIndex:indexPath.row]);
        
        SocializeCommentDetailsViewController* details = [[SocializeCommentDetailsViewController alloc] init];
        details.title = [NSString stringWithFormat: @"%d of %d", indexPath.row + 1, [_arrayOfComments count]];
        details.comment = entryComment;

        [_cache stopOperations];
        details.cache = _cache;
        
        UIBarButtonItem * backLeftItem = [self createLeftNavigationButtonWithCaption:@"Comments"];
        details.navigationItem.leftBarButtonItem = backLeftItem;	
        [backLeftItem release];
           
        [self.navigationController pushViewController:details animated:YES];
        [details release];
    }
}

-(IBAction)viewProfileButtonTouched:(UIButton*)sender {
    // TODO :  lets view the profile
    SocializeComment *comment = ((SocializeComment*)[_arrayOfComments objectAtIndex:sender.tag]);
    UIViewController *profileViewController = [self getProfileViewControllerForUser:comment.user];
    [self presentModalViewController:profileViewController animated:YES];
}

-(UIViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user {
    return [SocializeProfileViewController socializeProfileViewControllerForUser:user delegate:nil];
}

- (UITableViewCell *)tableView:(UITableView *)newTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"socializecommentcell";
	CommentsTableViewCell *cell = (CommentsTableViewCell*)[newTableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
    if (cell == nil) {
        
        // Create a temporary UIViewController to instantiate the custom cell.
        [[NSBundle mainBundle] loadNibNamed:@"CommentsTableViewCell" owner:self options:nil];
        // Grab a pointer to the custom cell.
        cell = commentsCell;
        self.commentsCell = nil;
        cell.accessibilityLabel = @"Comment Cell";
    }
	
	if ([_arrayOfComments count]) {
		
		SocializeComment* entryComment = ((SocializeComment*)[_arrayOfComments objectAtIndex:indexPath.row]);

		NSString *commentText = ((SocializeComment*)[_arrayOfComments objectAtIndex:indexPath.row]).text;
		NSString *commentHeadline = ((SocializeComment*)[_arrayOfComments objectAtIndex:indexPath.row]).user.userName;
        
        cell.locationPin.hidden = (entryComment.lat == nil);
        cell.btnViewProfile.tag = indexPath.row;
		cell.headlineLabel.text = commentHeadline;
		[cell setComment:commentText];
        
		cell.dateLabel.text = [self getDateString:((SocializeComment*)[_arrayOfComments objectAtIndex:indexPath.row]).date];
        
        CGRect cellRect = cell.bounds;
        CGRect datelabelRect = cell.dateLabel.frame;
        
        CGSize textSize = CGSizeMake(cellRect.size.width, datelabelRect.size.height);
        textSize = [cell.dateLabel.text sizeWithFont:cell.dateLabel.font constrainedToSize:textSize];
                    
        CGFloat xLabelCoordinate = cellRect.size.width - textSize.width - 7;
        datelabelRect = CGRectMake(xLabelCoordinate, datelabelRect.origin.y, textSize.width, datelabelRect.size.height);
        cell.dateLabel.frame = datelabelRect;
         
        CGRect locationPinFrame = cell.locationPin.frame;
        CGFloat xPinCoordinate = xLabelCoordinate - locationPinFrame.size.width - 7;
        locationPinFrame = CGRectMake(xPinCoordinate, locationPinFrame.origin.y, locationPinFrame.size.width, locationPinFrame.size.height);
        
        cell.locationPin.frame = locationPinFrame;
        
        UIImage * profileImage =(UIImage *)[_cache imageFromCache:entryComment.user.smallImageUrl];
		
		if (profileImage) 
		{
			cell.userProfileImage.image = profileImage;
		}
		else
		{
            cell.userProfileImage.image = [UIImage imageNamed:@"socialize-cell-image-default.png"];
			if (([entryComment.user.smallImageUrl length] > 0))
			{ 
                
                CompleteBlock completeAction = [[^(ImagesCache* cache)
                                                 {
                                                     if (!_arrayOfComments)
                                                         return;
                                                     
                                                     [_tableView reloadData];
                                                 } copy]autorelease];
                [_cache loadImageFromUrl: entryComment.user.smallImageUrl withLoader:[UrlImageLoader class] andCompleteAction:completeAction];
			}
		}
	}
	else {
		if (_isLoading){
			UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegularCell"] autorelease];
			cell.textLabel.text = @"Comments loading...";
			return cell;
		}
		else if (_errorLoading){

			UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegularCell"] autorelease];
			cell.textLabel.text = @"Error retrieving comments";
			return cell;

		}
		else {
			UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegularCell"] autorelease];
			cell.textLabel.text = @"Be the first commentator";
			return cell;
		}
	}
	return cell;
}

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

#pragma -

#pragma mark UITableViewDelegate
// Variable height support
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [CommentsTableViewCell getCellHeightForString:((SocializeComment*)[_arrayOfComments objectAtIndex:indexPath.row]).text] + 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	
	return 0;
}

#pragma mark -
- (void)addNoCommentsBackground{
	informationView.errorLabel.hidden = NO;
	informationView.noActivityImageView.hidden = NO;
	informationView.hidden = NO;
}

- (void)removeNoCommentsBackground{
	informationView.errorLabel.hidden = YES;
	informationView.noActivityImageView.hidden = YES;
	informationView.hidden = YES;
}

- (void)dealloc {
    [_cache release];
	[_entity release];
	[_arrayOfComments release];
	[_commentDateFormatter release];
    [footerView release];
    [_doneButton release];
    [_brandingButton release];
    [super dealloc];
}

@end
