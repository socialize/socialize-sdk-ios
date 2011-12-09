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
#import "SocializeLocationManager.h"
#import "SocializeAuthenticateService.h"
#import "ImagesCache.h"
#import "SocializeTableBGInfoView.h"
#import "SocializeCommentsService.h"

@interface SocializeCommentsTableViewController()
-(NSString*)getDateString:(NSDate*)date;
-(UIViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
@end

@implementation SocializeCommentsTableViewController

@synthesize cache = _cache;
@synthesize isLoading = _isLoading;

@synthesize brushedMetalBackground;
@synthesize backgroundView;
@synthesize roundedContainerView;

@synthesize noCommentsIconView;
@synthesize commentsCell;
@synthesize footerView;
@synthesize closeButton = _closeButton;
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

- (void)afterLoginAction {
    [self initializeContent];
}

- (void)loadContentForNextPageAtOffset:(NSInteger)offset {
    [self.socialize getCommentList:_entity.key
                             first:[NSNumber numberWithInteger:offset]
                              last:[NSNumber numberWithInteger:offset + self.pageSize]];
}

- (UIBarButtonItem*)closeButton {
    if (_closeButton == nil)
    {
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:@"Close"];
        [button addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _closeButton;
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

- (void)closeButtonPressed:(id)button {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark SocializeService Delegate

-(void)service:(SocializeService *)service didFail:(NSError *)error {
    if ([service isKindOfClass:[SocializeCommentsService class]]) {
        _isLoading = NO;
        if ( [[error localizedDescription] isEqualToString:@"Entity does not exist."] ) {
            // Entity does not yet exist. No content to fetch.
            [self receiveNewContent:nil];
        } else {
            [self failLoadingContent];
            [super service:service didFail:error];
        }
    } else {
        [super service:service didFail:error];
    }
}

-(void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    [self receiveNewContent:dataArray];
    _isLoading = NO;
}

#pragma mark -

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {   
    [super viewDidLoad];

    self.informationView.errorLabel.text = @"No comments to show.";
    
    self.tableView.scrollsToTop = YES;
    self.tableView.autoresizesSubviews = YES;

	UIImage * backgroundImage = [UIImage imageNamed:@"socialize-activity-bg.png"];
	UIImageView * imageBackgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = imageBackgroundView; 
	[imageBackgroundView release];
    
    self.tableView.accessibilityLabel = @"Comments Table View";
	self.view.clipsToBounds = YES;    
   
    
    self.navigationItem.leftBarButtonItem = self.brandingButton;
    self.navigationItem.rightBarButtonItem = self.closeButton;    
}

#pragma mark tableFooterViewDelegate

-(IBAction)addCommentButtonPressed:(id)sender 
{
    UINavigationController * pcNavController = [SocializePostCommentViewController postCommentViewControllerInNavigationControllerWithEntityURL:_entity.key delegate:self];
    [self presentModalViewController:pcNavController animated:YES];
}

- (void)composeMessageViewControllerDidCancel:(SocializeComposeMessageViewController *)composeMessageViewController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)postCommentViewController:(SocializePostCommentViewController *)postCommentViewController didCreateComment:(id<SocializeComment>)comment {
    [self insertContentAtHead:[NSArray arrayWithObject:comment]];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -

#pragma mark CommentViewController delegate

-(NSString*)getDateString:(NSDate*)startdate {
	return [NSDate getTimeElapsedString:startdate]; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.content count]){

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SocializeComment* entryComment = ((SocializeComment*)[self.content objectAtIndex:indexPath.row]);
        
        SocializeCommentDetailsViewController* details = [[SocializeCommentDetailsViewController alloc] init];
        details.title = [NSString stringWithFormat: @"%d of %d", indexPath.row + 1, [self.content count]];
        details.comment = entryComment;

        [_cache stopOperations];
        details.cache = _cache;
        
        UIBarButtonItem * backLeftItem = [self createLeftNavigationButtonWithCaption:@"Comments"];
        details.navigationItem.leftBarButtonItem = backLeftItem;	
           
        [self.navigationController pushViewController:details animated:YES];
        [details release];
    }
}

-(IBAction)viewProfileButtonTouched:(UIButton*)sender {
    // TODO :  lets view the profile
    SocializeComment *comment = ((SocializeComment*)[self.content objectAtIndex:sender.tag]);
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
	
    SocializeComment* entryComment = ((SocializeComment*)[self.content objectAtIndex:indexPath.row]);

    NSString *commentText = entryComment.text;
    NSString *commentHeadline = entryComment.user.userName;
    
    cell.locationPin.hidden = (entryComment.lat == nil);
    cell.btnViewProfile.tag = indexPath.row;
    cell.headlineLabel.text = commentHeadline;
    [cell setComment:commentText];
    
    cell.dateLabel.text = [self getDateString:entryComment.date];
    
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
                                                 if (!self.content)
                                                     return;
                                                 
                                                 [self.tableView reloadData];
                                             } copy]autorelease];
            [_cache loadImageFromUrl: entryComment.user.smallImageUrl withLoader:[UrlImageLoader class] andCompleteAction:completeAction];
        }
    }
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"socialize-cell-bg.png"]] autorelease];

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
	return [CommentsTableViewCell getCellHeightForString:((SocializeComment*)[self.content objectAtIndex:indexPath.row]).text] + 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	
	return 0;
}

- (void)dealloc {
    [_cache release];
	[_entity release];
	[_commentDateFormatter release];
    [footerView release];
    [_closeButton release];
    [_brandingButton release];
    [super dealloc];
}

@end
