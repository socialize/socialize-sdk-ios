//
//  SocializeCommentsTableViewController.m
//  appbuildr
//
//  Created by Fawad Haider on 12/2/10.
//  Copyright 2010. All rights reserved.
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
#import "SocializeActivityDetailsViewController.h"
#import "SocializeSubscriptionService.h"
#import "SocializeBubbleView.h"
#import "UIView+Layout.h"
#import "SocializeNotificationToggleBubbleContentView.h"
#import "CommentsTableFooterView.h"

@interface SocializeCommentsTableViewController()
-(NSString*)getDateString:(NSDate*)date;
-(UIViewController *)getProfileViewControllerForUser:(id<SocializeUser>)user;
-(SocializeActivityDetailsViewController *)createActivityDetailsViewController:(id<SocializeComment>) entryComment;
- (void)getSubscriptionStatus;
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
@synthesize entity = _entity;

@synthesize delegate = delegate_;
@synthesize bubbleView = bubbleView_;
@synthesize bubbleContentView = bubbleContentView_;

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

- (void)afterLoginAction:(BOOL)userChanged {
    [self initializeContent];
    [self getSubscriptionStatus];
}

- (void)loadContentForNextPageAtOffset:(NSInteger)offset {
    if ([_entity.key length] > 0) {
        [self.socialize getCommentList:_entity.key
                                 first:[NSNumber numberWithInteger:offset]
                                  last:[NSNumber numberWithInteger:offset + self.pageSize]];
    }
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
    if ([self.delegate respondsToSelector:@selector(commentsTableViewControllerDidFinish:)]) {
        [self.delegate commentsTableViewControllerDidFinish:self];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
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

- (BOOL)elementsHaveActiveSubscription:(NSArray*)elements {
    for (id<SocializeSubscription> subscription in elements) {
        if ([subscription subscribed]) {
            return YES;
        }
    }
    
    return NO;
}

-(void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    if ([service isKindOfClass:[SocializeSubscriptionService class]]) {
        BOOL subscribed = [self elementsHaveActiveSubscription:dataArray];
        self.footerView.subscribedButton.enabled = YES;
        self.footerView.subscribedButton.selected = subscribed;
    } else if ([service isKindOfClass:[SocializeCommentsService class]]) {
        [self receiveNewContent:dataArray];
        _isLoading = NO;
    }
}

- (void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object {
    
}

- (void)getSubscriptionStatus {
    if ([_entity.key length] > 0) {
        [self.socialize getSubscriptionsForEntityKey:_entity.key first:nil last:nil];
    }
}

- (SocializeNotificationToggleBubbleContentView*)bubbleContentView {
    if (bubbleContentView_ == nil) {
        bubbleContentView_ = [[SocializeNotificationToggleBubbleContentView notificationToggleBubbleContentViewFromNib] retain];
    }
    
    return bubbleContentView_;
}

- (SocializeBubbleView*)bubbleView {
    if (bubbleView_ == nil) {
        bubbleView_ = [[SocializeBubbleView alloc] initWithSize:CGSizeMake(240, 100)];
        [bubbleView_.contentView addSubview:self.bubbleContentView];
    }
    return bubbleView_;
}

- (IBAction)subscribedButtonPressed:(id)sender {
    if (self.footerView.subscribedButton.selected) {
        self.footerView.subscribedButton.selected = NO;
        [self.socialize unsubscribeFromCommentsForEntityKey:_entity.key];
    } else {
        self.footerView.subscribedButton.selected = YES;
        [self.socialize subscribeToCommentsForEntityKey:_entity.key];
    }
    
    if (self.bubbleView != nil) {
        [self.bubbleView removeFromSuperview];
        self.bubbleView = nil;
    }
    [self.bubbleContentView configureForNotificationsEnabled:self.footerView.subscribedButton.selected];
    
    CGRect buttonRect = [self.footerView.subscribedButton convertRect:self.footerView.subscribedButton.frame toView:self.view];
    [self.bubbleView showFromRect:buttonRect inView:self.view offset:CGPointMake(0, -15) animated:YES];
    [self.bubbleView performSelector:@selector(animateOutAndRemoveFromSuperview) withObject:nil afterDelay:2];
}

#pragma mark -

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {   
    [super viewDidLoad];

    self.informationView.errorLabel.text = @"No comments to show.";
    
    self.tableView.scrollsToTop = YES;
    self.tableView.autoresizesSubviews = YES;

    self.tableView.accessibilityLabel = @"Comments Table View";
	self.tableView.clipsToBounds = YES;    
    
    
    self.navigationItem.leftBarButtonItem = self.brandingButton;
    self.navigationItem.rightBarButtonItem = self.closeButton;    
    
    self.footerView.subscribedButton.enabled = NO;
    
    if (![self.socialize notificationsAreConfigured]) {
        DebugLog(SOCIALIZE_NOTIFICATIONS_NOT_CONFIGURED_MESSAGE);
        
        [self.footerView hideSubscribedButton];
    }
}

#pragma mark tableFooterViewDelegate

-(IBAction)addCommentButtonPressed:(id)sender 
{
    UINavigationController * pcNavController = [SocializePostCommentViewController postCommentViewControllerInNavigationControllerWithEntityURL:_entity.key delegate:self];
    [self presentModalViewController:pcNavController animated:YES];
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)postCommentViewController:(SocializePostCommentViewController *)postCommentViewController didCreateComment:(id<SocializeComment>)comment {
    [self insertContentAtHead:[NSArray arrayWithObject:comment]];
    
    self.footerView.subscribedButton.selected = !postCommentViewController.dontSubscribeToDiscussion;
    
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
        
        SocializeActivityDetailsViewController* details = [self createActivityDetailsViewController:entryComment];

        details.title = [NSString stringWithFormat: @"%d of %d", indexPath.row + 1, [self.content count]];

        [_cache stopOperations];
        
        UIBarButtonItem * backLeftItem = [self createLeftNavigationButtonWithCaption:@"Comments"];
        details.navigationItem.leftBarButtonItem = backLeftItem;	
           
        [self.navigationController pushViewController:details animated:YES];
    }
}
-(SocializeActivityDetailsViewController *)createActivityDetailsViewController:(id<SocializeComment>) entryComment{
    return [[[SocializeActivityDetailsViewController alloc] initWithActivity:entryComment] autorelease];
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
    [bubbleContentView_ release];
    [bubbleView_ release];
    
    [super dealloc];
}

@end
