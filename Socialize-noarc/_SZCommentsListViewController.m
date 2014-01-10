//
//  _SZCommentsListViewController.m
//  appbuildr
//
//  Created by Fawad Haider on 12/2/10.
//  Copyright 2010. All rights reserved.
//

#import "_SZCommentsListViewController.h"
#import "CommentsTableViewCell.h"
#import "NSDateAdditions.h"
#import "SocializeCommentDetailsViewController.h"
#import "_SZComposeCommentViewController.h"
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
#import "SZNavigationController.h"
#import "SocializePrivateDefinitions.h"
#import "SDKHelpers.h"
#import "SZSmartAlertUtils.h"
#import "SZCommentUtils.h"
#import "SZComposeCommentViewController.h"
#import "socialize_globals.h"

@interface _SZCommentsListViewController()
@end

@implementation _SZCommentsListViewController

@synthesize cache = _cache;
@synthesize brushedMetalBackground;
@synthesize backgroundView;
@synthesize roundedContainerView;
@synthesize noCommentsIconView;
@synthesize commentsCell;
@synthesize footerView;
@synthesize closeButton = _closeButton;
@synthesize brandingButton = _brandingButton;
@synthesize entity = _entity;
@synthesize bubbleView = bubbleView_;
@synthesize bubbleContentView = bubbleContentView_;
@synthesize showNotificationHintOnAppear = showNotificationHintOnAppear_;

@synthesize delegate = delegate_;
@synthesize isLoading = _isLoading;

- (void)dealloc {
    [_cache stopOperations];
    [_cache release];
    [brushedMetalBackground release];
    [backgroundView release];
    [roundedContainerView release];
    [noCommentsIconView release];
    [commentsCell release];
    [footerView release];
    [_closeButton release];
    [_brandingButton release];
	[_entity release];
    [bubbleView_ release];
    [bubbleContentView_ release];
	[_commentDateFormatter release];
    
    [super dealloc];
}

+ (UIViewController*)socializeCommentsTableViewControllerForEntity:(NSString*)entityName {
    _SZCommentsListViewController* commentsController =
    [[[_SZCommentsListViewController alloc] initWithNibName:@"_SZCommentsListViewController"
                                                     bundle:nil
                                             entryUrlString:entityName] autorelease];
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:commentsController] autorelease];
    
    return nav;
}

+ (_SZCommentsListViewController*)commentsListViewControllerWithEntityKey:(NSString*)entityKey {
    _SZCommentsListViewController* commentsController = [[[_SZCommentsListViewController alloc] initWithEntityKey:entityKey] autorelease];
    return commentsController;
}

+ (_SZCommentsListViewController*)commentsListViewControllerWithEntity:(id<SZEntity>)entity {
    return [[[self alloc] initWithEntity:entity] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entryUrlString:(NSString*) entryUrlString {
    return [self initWithEntityKey:entryUrlString];
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
        
		_errorLoading = NO;
		_isLoading = YES;
        
		_commentDateFormatter = [[NSDateFormatter alloc] init];
		[_commentDateFormatter setDateFormat:@"hh:mm:ss zzz"];
        
        /*Socialize inits*/
        _entity = (SocializeEntity*)[entity retain];
        
        /* cache for the images*/
        _cache = [[ImagesCache alloc] init];
        
	}
    return self;
}

- (id)initWithEntityKey:(NSString*)entityKey {
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:nil];
    return [self initWithEntity:entity];
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
    if (_closeButton == nil) {
        UIButton *button = [UIButton blueSocializeNavBarButtonWithTitle:@"Close"];
        [button addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _closeButton;
}

-(UIBarButtonItem*)brandingButton {
    if(_brandingButton == nil) {
        NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"commentsNavBarLeftItemView" owner:self options:nil];
        UIView* brandingView = [ nibViews objectAtIndex: 0];
        _brandingButton = [[UIBarButtonItem alloc] initWithCustomView:brandingView];
    }
    return  _brandingButton;
}

- (void)closeButtonPressed:(id)button {
    if (self.completionBlock != nil) {
        self.completionBlock();
    }
    else if ([self.delegate respondsToSelector:@selector(commentsTableViewControllerDidFinish:)]) {
        [self.delegate commentsTableViewControllerDidFinish:self];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)showAndHideBubble {
    CGRect buttonRect = [self.footerView.subscribedButton convertRect:self.footerView.subscribedButton.frame toView:self.view];
    [self.bubbleView showFromRect:buttonRect inView:self.view offset:CGPointMake(0, -15) animated:YES];
    [self.bubbleView performSelector:@selector(animateOutAndRemoveFromSuperview) withObject:nil afterDelay:2];
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
    
    [self showAndHideBubble];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.showNotificationHintOnAppear) {
        self.showNotificationHintOnAppear = NO;
        [self.bubbleContentView configureForNotificationsEnabled:self.footerView.subscribedButton.selected];
        self.bubbleContentView.descriptionLabel.text = @"Tap here to toggle notifications on and off for this thread.";
        [self showAndHideBubble];
    }
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
    
    if (![SZSmartAlertUtils isAvailable]) {
        [self.footerView hideSubscribedButton];
    }
    
    //iOS 7 adjustments for nav bar and cell separator
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
}

#pragma mark tableFooterViewDelegate

-(IBAction)addCommentButtonPressed:(id)sender {
    WEAK(self) weakSelf = self;
    
    SZComposeCommentViewController *composer = [[[SZComposeCommentViewController alloc] initWithEntity:_entity] autorelease];
    composer.completionBlock = ^(id<SZComment> comment) {
        [weakSelf postCommentViewController:composer._composeCommentViewController didCreateComment:comment];
    };
    
    composer.cancellationBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    composer.display = self;
    composer.commentOptions = self.commentOptions;
    
    [self presentViewController:composer animated:YES completion:nil];
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self notifyDelegateOfCompletion];
}

- (void)postCommentViewController:(_SZComposeCommentViewController *)postCommentViewController didCreateComment:(id<SocializeComment>)comment {
    [self insertContentAtHead:[NSArray arrayWithObject:comment]];
    self.footerView.subscribedButton.selected = !postCommentViewController.dontSubscribeToDiscussion;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

#pragma mark CommentViewController delegate

-(NSString*)getDateString:(NSDate*)startdate {
	return [NSDate getTimeElapsedString:startdate]; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    WEAK(self) weakSelf = self;

    // TODO :  lets view the profile
    SocializeComment *comment = ((SocializeComment*)[self.content objectAtIndex:sender.tag]);
    
    _SZUserProfileViewController *profile = [_SZUserProfileViewController profileViewController];
    profile.user = comment.user;
    profile.completionBlock = ^(id<SZFullUser> user) {
        [weakSelf.navigationController popToViewController:self animated:YES];
    };
    [self.navigationController pushViewController:profile animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)newTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"socializecommentcell";
	CommentsTableViewCell *cell = (CommentsTableViewCell*)[newTableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
    if (cell == nil) {
        // Create a temporary UIViewController to instantiate the custom cell.
        [[NSBundle mainBundle] loadNibNamed:[CommentsTableViewCell nibName]
                                      owner:self
                                    options:nil];
        // Grab a pointer to the custom cell.
        cell = commentsCell;
        self.commentsCell = nil;
        cell.accessibilityLabel = @"Comment Cell";
    }
	
    SocializeComment* entryComment = ((SocializeComment*)[self.content objectAtIndex:indexPath.row]);

    NSString *commentText = entryComment.text;
    NSString *commentHeadline = entryComment.user.displayName;
    
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
    locationPinFrame = CGRectMake(xPinCoordinate,
                                  locationPinFrame.origin.y,
                                  locationPinFrame.size.width,
                                  locationPinFrame.size.height);
    
    cell.locationPin.frame = locationPinFrame;
    
    UIImage * profileImage =(UIImage *)[_cache imageFromCache:entryComment.user.smallImageUrl];
    if (profileImage) {
        cell.userProfileImage.image = profileImage;
    }
    else {
        cell.userProfileImage.image = [cell defaultProfileImage];
        if (([entryComment.user.smallImageUrl length] > 0)) {
            CompleteBlock completeAction = [[^(ImagesCache* cache) {
                                                 if (!self.content)
                                                     return;
                                                 [self.tableView reloadData];
                                             } copy] autorelease];
            [_cache loadImageFromUrl:entryComment.user.smallImageUrl
                          withLoader:[UrlImageLoader class]
                   andCompleteAction:completeAction];
        }
    }
    
    //different impls may not have a bgImage
    if(cell.bgImage != nil) {
        cell.bgImage.image = [cell defaultBackgroundImage];
    }
	return cell;
}

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

#pragma mark -

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
}

@end
