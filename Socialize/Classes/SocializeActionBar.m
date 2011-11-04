/*
 * SocializeActionBar.m
 * SocializeSDK
 *
 * Created on 10/5/11.
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

#import "SocializeActionBar.h"
#import "SocializeActionBarView.h"
#import "SocializeAuthenticateService.h"
#import "SocializeLikeService.h"
#import "SocializeCommentsTableViewController.h"
#import "UIButton+Socialize.h"
#import "UINavigationBarBackground.h"
#import "SocializeView.h"
#import "SocializeEntity.h"
#import "BlocksKit.h"
#import "SocializeShareBuilder.h"
#import "SocializeFacebookInterface.h"
#import "SocializeActionView.h"
#import "SocializeRecommendService.h"

@interface SocializeActionBar()
@property(nonatomic, retain) id<SocializeLike> entityLike;
@property(nonatomic, retain) id<SocializeView> entityView;

-(void) shareViaEmail;
-(void)shareViaFacebook;
-(void)displayComposerSheet;
- (void)getRecommendations;
@end

@implementation SocializeActionBar

@synthesize parentViewController;
@synthesize entity;
@synthesize entityLike;
@synthesize entityView;
@synthesize ignoreNextView = _ignoreNextView;
@synthesize shareActionSheet = _shareActionSheet;
@synthesize shareComposer = _shareComposer;
@synthesize likeRecommendations = likeRecommendations_;
@synthesize actionView = actionView_;
@synthesize recommendService = recommendService_;
@synthesize recommendCell = recommendCell_;

+(SocializeActionBar*)actionBarWithUrl:(NSString*)url presentModalInController:(UIViewController*)controller
{
    SocializeActionBar* bar = [[[SocializeActionBar alloc] initWithEntityUrl:url presentModalInController:controller] autorelease];
    return bar;
}

-(id)initWithEntityUrl:(NSString*)url presentModalInController:(UIViewController*)controller
{
    if ((self = [self initWithEntity:nil presentModalInController:controller])) {
        id<SocializeEntity> newEntity = [self.socialize createObjectForProtocol:@protocol(SocializeEntity)];
        [newEntity setKey:url];
        self.entity = newEntity;
    }
    return self;
}

-(id)initWithEntity:(id<SocializeEntity>)socEntity presentModalInController:(UIViewController*)controller
{
    self = [super init];
    if(self)
    {
        self.entity = socEntity;
        self.parentViewController = controller;
    }
    return self;
}

- (void)dealloc
{
    [entity release];
    [entityView release];
    [entityLike release];
    [(SocializeActionBarView*)self.view setDelegate: nil];
    [comentsNavController release];
    self.parentViewController = nil;
    self.shareComposer = nil;
    self.shareActionSheet = nil;
    self.likeRecommendations = nil;
    self.actionView = nil;
    self.recommendCell = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.actionView = [[[SocializeActionView alloc] initWithFrame:CGRectZero] autorelease];
    self.actionView.delegate = self;
    self.view = self.actionView;
    /*
    SocializeActionBarView* actionView = [[SocializeActionBarView alloc] initWithFrame:CGRectZero];
    self.view = actionView;
    actionView.delegate = self;
    [actionView release];
     */
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    comentsNavController = [[SocializeCommentsTableViewController socializeCommentsTableViewControllerForEntity:[entity key]] retain];
}


-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    if ([dataArray count]){
        id<SocializeObject> object = [dataArray objectAtIndex:0];
        if ([object conformsToProtocol:@protocol(SocializeEntity)])
        {
            self.entity = (id<SocializeEntity>)object;          
            [self.actionView.barView updateCountsWithViewsCount:[NSNumber numberWithInt:entity.views] withLikesCount:[NSNumber numberWithInt:entity.likes] isLiked:entityLike!=nil withCommentsCount:[NSNumber numberWithInt:entity.comments]];
        }
        if ([object conformsToProtocol:@protocol(SocializeLike)])
        {
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                id<SocializeLike> like = (id<SocializeLike>)obj;
                if(like.user.objectID == self.socialize.authenticatedUser.objectID)
                {
                    self.entityLike = like;
                    [self.actionView.barView updateLikesCount:[NSNumber numberWithInt:self.entityLike.entity.likes] liked:YES];
                    [self getRecommendations];
                    *stop = YES;
                }
            }];
        }
    }    
}

-(void)service:(SocializeService *)service didDelete:(id<SocializeObject>)object
{
    [self.actionView.barView updateLikesCount:[NSNumber numberWithInt:entityLike.entity.likes-1] liked:NO];
    self.entityLike = nil;
    [self.actionView.barView unlockButtons];
    [self.actionView.recommendationsView hide];

}

- (SocializeRecommendService*)recommendService {
    if (recommendService_ == nil) {
        recommendService_ = [[SocializeRecommendService alloc] init];
    }
    
    return recommendService_;
}

- (void)getRecommendations {
    SocializeLike *fakeLike = [[[SocializeLike alloc] init] autorelease];
    fakeLike.objectID = 10323;
    [self.recommendService getLikeRecommendation:fakeLike completion:^(NSDictionary *recommendations, NSError *error) {
        if (error != nil) {
            NSLog(@"WARN: GIVING ME SOME BAD RECOMMENDATIONS: %@", error);
            return;
        }
        self.likeRecommendations = [recommendations objectForKey:@"items"];
        if ([self.likeRecommendations count]) {
            [self.actionView.recommendationsView.tableView reloadData];
            [self.actionView.recommendationsView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
    }];
}

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object
{
    if([object conformsToProtocol:@protocol(SocializeView)])
    {
        self.entityView = (id<SocializeView>)object;
        [self.actionView.barView updateViewsCount:[NSNumber numberWithInt:entityView.entity.views]];
    }
    if([object conformsToProtocol:@protocol(SocializeLike)])
    {
        self.entityLike = (id<SocializeLike>)object;
        [self.actionView.barView updateLikesCount:[NSNumber numberWithInt:entityLike.entity.likes] liked:YES];
        [self.actionView.barView unlockButtons];
        [self getRecommendations];
    } 
    
    if([self.socialize isAuthenticatedWithFacebook] && ([object conformsToProtocol:@protocol(SocializeLike)] || [object conformsToProtocol:@protocol(SocializeShare)])
      )
    {
        SocializeShareBuilder* shareBuilder = [[SocializeShareBuilder new] autorelease];
        shareBuilder.shareProtocol = [[SocializeFacebookInterface new] autorelease];
        shareBuilder.shareObject = (id<SocializeActivity>)object;
        [shareBuilder performShareForPath:@"me/feed"]; 
    }
    
    // Refresh from server
    [self.socialize getEntityByKey:[entity key]];
}

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    [self.actionView.barView updateCountsWithViewsCount:[NSNumber numberWithInt:0] withLikesCount:[NSNumber numberWithInt:0] isLiked:NO withCommentsCount:[NSNumber numberWithInt:0]];
    if([service isKindOfClass:[SocializeAuthenticateService class]])
    {
        [super service:service didFail:error];
    }
    else
    {       
        if(![[error localizedDescription] isEqualToString:@"Entity does not exist."])
            [self showAllertWithText:[error localizedDescription] andTitle:@"Get entiry failed"];
        
        if([service isKindOfClass:[SocializeLikeService class]])
            [self.actionView.barView unlockButtons];
    }
}

-(void)didAuthenticate:(id<SocializeUser>)user
{
    [super didAuthenticate:user];
    //remove like status because we do not know it for new user yet.
    self.entityLike = nil;
    [self.actionView.barView updateIsLiked:NO];
}

#pragma mark Socialize base class method
-(void) startLoadAnimationForView: (UIView*) view;
{
}

-(void) stopLoadAnimation
{
}

-(void)afterAnonymouslyLoginAction
{
    if (self.ignoreNextView) {
        // Refresh now
        [self.socialize getEntityByKey:[entity key]];
        self.ignoreNextView = NO;
    } else {
        // Refresh will happen after the view
        [self.socialize viewEntity:entity longitude:nil latitude:nil];
    }

    if(entityLike == nil)
        [self.socialize getLikesForEntityKey:[entity key] first:nil last:nil];
}

-(void)socializeActionViewWillAppear:(SocializeActionView *)actionView{
    [actionView.barView startActivityForUpdateViewsCount];
    [self performAutoAuth];
}

-(void)socializeActionViewWillDisappear:(SocializeActionView *)socializeActionView {
}

#pragma Socialize Action view delefate

-(void)commentButtonTouched:(id)sender
{
    self.ignoreNextView = YES;
    [self.parentViewController presentModalViewController:comentsNavController animated:YES];
}

-(void)likeButtonTouched:(id)sender
{
    [self.actionView.barView lockButtons];
    
    if(entityLike)
        [self.socialize unlikeEntity: entityLike];
    else
        [self.socialize likeEntityWithKey:[entity key] longitude:nil latitude:nil];
}

- (UIActionSheet*)shareActionSheet {
    if (_shareActionSheet == nil) {
        _shareActionSheet = [[UIActionSheet sheetWithTitle:nil] retain];
        
        if(self.socialize.isAuthenticatedWithFacebook)
            [_shareActionSheet addButtonWithTitle:@"Share on Facebook" handler:^{ [self shareViaFacebook]; }];
        
        [_shareActionSheet addButtonWithTitle:@"Share via Email" handler:^{ [self shareViaEmail]; }];
        
        [_shareActionSheet setCancelButtonWithTitle:nil handler:^{ NSLog(@"Never mind, then!"); }];
    }
    return _shareActionSheet;
}
-(void)shareButtonTouched: (id) sender
{    
    [self.shareActionSheet showInView:self.view.window];
}

-(void)shareViaFacebook
{
    [self.socialize createShareForEntity:self.entity medium:Facebook text:@"Would like to share with you my interest"];
}

#pragma mark Share via email

-(void) shareViaEmail
{
    [self displayComposerSheet];
}

- (MFMailComposeViewController*)shareComposer {
    if (_shareComposer == nil) {
        _shareComposer = [[MFMailComposeViewController alloc] init];
        _shareComposer.completionBlock = ^(MFMailComposeResult result, NSError *error)
        {
            // Notifies users about errors associated with the interface
            switch (result)
            {
                case MFMailComposeResultCancelled:
                    NSLog(@"Result: canceled");
                    break;
                case MFMailComposeResultSaved:
                    NSLog(@"Result: saved");
                    break;
                case MFMailComposeResultSent:
                    NSLog(@"Result: sent");
                    break;
                case MFMailComposeResultFailed:
                    NSLog(@"Result: failed with error %@", [error localizedDescription]);
                    break;
                default:
                    NSLog(@"Result: not sent");
                    break;
            }
        };
        [_shareComposer setSubject:@"Share with you my interest!"];
    }
    
    return _shareComposer;
}

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat: @"I thought you would find this interesting: %@ %@", entity.name, entity.key];
    [self.shareComposer setMessageBody:emailBody isHTML:NO];

	[self.parentViewController presentModalViewController:self.shareComposer animated:YES];
}

-(SocializeRecommendCell*)getRecommendCellInTableView:(UITableView*)tableView {
	static NSString *CellIdentifier = @"SocializeRecommendCell";
	
	SocializeRecommendCell *cell =(SocializeRecommendCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"SocializeRecommendCell" owner:self options:nil];
		cell = self.recommendCell;
		self.recommendCell = nil;
	}
	
	return cell;	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SocializeRecommendCell *cell = [self getRecommendCellInTableView:tableView];

    NSDictionary *dictionary = [self.likeRecommendations objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dictionary objectForKey:@"name"];
    cell.commentsCount.text = [[dictionary objectForKey:@"comments"] description];
    cell.likesCount.text = [[dictionary objectForKey:@"likes"] description];
    cell.sharesCount.text = [[dictionary objectForKey:@"shares"] description];
    cell.viewsCount.text = [[dictionary objectForKey:@"views"] description];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.likeRecommendations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
