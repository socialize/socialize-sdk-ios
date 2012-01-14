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
#import "SocializeActionView.h"
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
#import "SocializePostShareViewController.h"
#import "SocializeEntityService.h"
#import "SocializeProfileViewController.h"

@interface SocializeActionBar()
@property (nonatomic, retain) id<SocializeView> entityView;
@property (nonatomic, retain) id<SocializeLike> entityLike;
@property (nonatomic, assign) BOOL finishedAskingServerForExistingLike;
@property (nonatomic, assign) BOOL initialized;

-(void) shareViaEmail;
-(void)shareViaFacebook;
-(void)displayComposerSheet;
-(void)askServerForExistingLike;
-(void)reloadEntity;

@end

@implementation SocializeActionBar

@synthesize presentModalInViewController = _presentModalInViewController;
@synthesize entity = _entity;
@synthesize entityLike = entityLike_;
@synthesize entityView = entityView_;
@synthesize ignoreNextView = ignoreNextView_;
@synthesize shareActionSheet = shareActionSheet_;
@synthesize shareComposer = shareComposer_;
@synthesize commentsNavController = commentsNavController_;
@synthesize finishedAskingServerForExistingLike = finishedAskingServerForExistingLike_;
@synthesize noAutoLayout = noAutoLayout_;
@synthesize initialized = initialized_;
@synthesize delegate = delegate_;
@synthesize unconfiguredEmailAlert = unconfiguredEmailAlert_;

- (void)dealloc
{
    self.presentModalInViewController = nil;
    self.entity = nil;
    self.entityLike = nil;
    self.entityView = nil;
    self.shareActionSheet = nil;
    self.shareComposer = nil;
    self.commentsNavController = nil;
    self.unconfiguredEmailAlert = nil;
    
    if (self.isViewLoaded) {
        [(SocializeActionView*)self.view setDelegate: nil];
    }
    
    [super dealloc];
}


+(SocializeActionBar*)actionBarWithKey:(NSString*)url presentModalInController:(UIViewController*)controller
{
    SocializeActionBar* bar = [[[SocializeActionBar alloc] initWithEntityUrl:url presentModalInController:controller] autorelease];
    return bar;
}

+(SocializeActionBar*)actionBarWithUrl:(NSString*)url presentModalInController:(UIViewController*)controller {
    return [self actionBarWithKey:url presentModalInController:controller];
}

-(id)initWithEntityKey:(NSString*)key presentModalInController:(UIViewController*)controller
{
    id<SocializeEntity> newEntity = [self.socialize createObjectForProtocol:@protocol(SocializeEntity)];
    [newEntity setKey:key];
    return [self initWithEntity:newEntity presentModalInController:controller];
}

-(id)initWithEntityUrl:(NSString*)url presentModalInController:(UIViewController*)controller {
    return [self initWithEntityKey:url presentModalInController:controller];
}

-(id)initWithEntity:(id<SocializeEntity>)socEntity presentModalInController:(UIViewController*)controller
{
    self = [super init];
    if(self)
    {
        self.entity = socEntity;
        self.presentModalInViewController = controller;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)setNoAutoLayout:(BOOL)noAutoLayout {
    noAutoLayout_ = noAutoLayout;
    [(SocializeActionView*)self.view setNoAutoLayout:noAutoLayout];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    SocializeActionView* actionView = [[SocializeActionView alloc] initWithFrame:CGRectMake(0, 0, 320, SOCIALIZE_ACTION_PANE_HEIGHT)];
    self.view = actionView;
    actionView.delegate = self;
    [actionView release];
}

- (UIViewController*)commentsNavController {
    if (commentsNavController_ == nil) {
        commentsNavController_ = [[SocializeCommentsTableViewController socializeCommentsTableViewControllerForEntity:self.entity.key] retain];
    }
    return commentsNavController_;
}

#pragma mark Socialize base class method
-(void) startLoadAnimationForView: (UIView*) view;
{
}

-(void) stopLoadAnimation
{
}

- (BOOL)shouldAutoAuthOnAppear {
    return NO;
}

- (void)appear {
    if (!self.initialized) {
        [(SocializeActionView*)self.view hideButtons];
    }
    
    if (self.ignoreNextView) {
        self.ignoreNextView = NO;
        
        // Normally, we reload the entity after viewing. Since we aren't viewing, reload it now.
        // FIXME This is only to update comments count, we do not truly have to reload
        [self reloadEntity];
        return;
    }
    [self.socialize viewEntity:self.entity longitude:nil latitude:nil];    

    if (!self.finishedAskingServerForExistingLike) {
        [self askServerForExistingLike];
    }
}

- (void)afterLoginAction {
    [self appear];
}

-(void)socializeActionViewWillAppear:(SocializeActionView *)socializeActionView {
    [self performAutoAuth];
}

-(void)socializeActionViewWillDisappear:(SocializeActionView *)socializeActionView {
}

#pragma Socialize Action view delefate

-(void)commentButtonTouched:(id)sender
{
    self.ignoreNextView = YES;
    
    // Reset for now, since we yet don't have refresh functionality
    self.commentsNavController = nil;
    
    [self.presentModalInViewController presentModalViewController:self.commentsNavController animated:YES];
}

-(void)likeButtonTouched:(id)sender
{
    [(SocializeActionView*)self.view lockButtons];
    
    if(self.entityLike)
        [self.socialize unlikeEntity:self.entityLike];
    else
        [self.socialize likeEntityWithKey:self.entity.key longitude:nil latitude:nil];
}

-(void)viewButtonTouched:(id)sender
{
    self.ignoreNextView = YES;
    UINavigationController *nav = [SocializeProfileViewController currentUserProfileWithDelegate:nil];
    [self.presentModalInViewController presentModalViewController:nav animated:YES];
}

- (UIActionSheet*)shareActionSheet {
    if (shareActionSheet_ == nil) {
        shareActionSheet_ = [[UIActionSheet sheetWithTitle:nil] retain];
        
        __block __typeof__(self) weakSelf = self;
        if([self.socialize facebookAvailable])
            [shareActionSheet_ addButtonWithTitle:@"Share on Facebook" handler:^{ [weakSelf shareViaFacebook]; }];

        [shareActionSheet_ addButtonWithTitle:@"Share via Email" handler:^{ [weakSelf shareViaEmail]; }];
        
        [shareActionSheet_ setCancelButtonWithTitle:nil handler:^{  }];
    }
    return shareActionSheet_;
}

- (void)showActionSheet:(UIActionSheet*)actionSheet {
    if ([self.delegate respondsToSelector:@selector(actionBar:wantsDisplayActionSheet:)]) {
        
        // Let the delegate override action sheet display if they want
        [self.delegate actionBar:self wantsDisplayActionSheet:actionSheet];
        
    } else if ([self.presentModalInViewController isKindOfClass:[UITabBarController class]]) {
        
        // Some default behavior for UITabBarController (showFromTabBar:)
        [actionSheet showFromTabBar:[(UITabBarController*)self.presentModalInViewController tabBar]];
        
    } else {
        
        // Normal Behavior: just display in modal target's view
        [actionSheet showInView:self.presentModalInViewController.view];
    }
}

-(void)shareButtonTouched: (id) sender
{
    [self showActionSheet:self.shareActionSheet];
}

-(void)shareViaFacebook
{
    self.ignoreNextView = YES;
    UINavigationController *shareController = [SocializePostShareViewController postShareViewControllerInNavigationControllerWithEntityURL:self.entity.key];
    [self.presentModalInViewController presentModalViewController:shareController animated:YES];
}

#pragma mark Share via email

- (UIAlertView*)unconfiguredEmailAlert {
    if (unconfiguredEmailAlert_ == nil) {
        unconfiguredEmailAlert_ = [[UIAlertView alloc] initWithTitle:@"Mail is not Configured" message:@"Please configure at least one mail account before using this feature."];
        [unconfiguredEmailAlert_ addButtonWithTitle:@"Add Account" handler:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=ACCOUNT_SETTINGS"]];
        }];
        [unconfiguredEmailAlert_ setCancelButtonWithTitle:@"Ok" handler:^{}];
    }
    
    return unconfiguredEmailAlert_;
}

- (BOOL)canSendMail {
    return [MFMailComposeViewController canSendMail];
}

-(void) shareViaEmail
{
    if ([self canSendMail]) {
        [self displayComposerSheet];
    } else {
        [self.unconfiguredEmailAlert show];
    }
}

- (MFMailComposeViewController*)shareComposer {
    if (shareComposer_ == nil) {
        shareComposer_ = [[MFMailComposeViewController alloc] init];
        shareComposer_.completionBlock = ^(MFMailComposeResult result, NSError *error)
        {
            // Notifies users about errors associated with the interface
            switch (result)
            {
                case MFMailComposeResultCancelled:
                    break;
                case MFMailComposeResultSaved:
                    break;
                case MFMailComposeResultSent:
                    break;
                case MFMailComposeResultFailed:
                    break;
                default:
                    break;
            }
        };
    }
    
    return shareComposer_;
}

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
    NSString *subject = self.entity.name;
    if ([subject length] == 0) {
        subject = self.entity.key;
    }
    [self.shareComposer setSubject:subject];

    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat: @"I thought you would find this interesting: %@ %@", self.entity.name, self.entity.key];
    [self.shareComposer setMessageBody:emailBody isHTML:NO];

	[self.presentModalInViewController presentModalViewController:self.shareComposer animated:YES];
}

- (void)reloadEntity {
    // Refresh from server
    [self.socialize getEntityByKey:self.entity.key];
}

- (void)finishedGettingEntities:(NSArray*)entities {
    if ([entities count] < 1) {
        return;
    }
    
    if (!self.initialized) {
        self.initialized = YES;
        [(SocializeActionView*)self.view showButtons];
    }
    
    id<SocializeEntity> entity = [entities objectAtIndex:0];
    self.entity = entity;
    [(SocializeActionView*)self.view updateCountsWithViewsCount:[NSNumber numberWithInt:entity.views]
                                                 withLikesCount:[NSNumber numberWithInt:entity.likes]
                                                        isLiked:self.entityLike != nil
                                              withCommentsCount:[NSNumber numberWithInt:entity.comments]];    
}

- (void)askServerForExistingLike {
    [self.socialize getLikesForEntityKey:self.entity.key first:nil last:nil];    
}

- (void)finishedGettingLikes:(NSArray*)likes {
    self.finishedAskingServerForExistingLike = YES;
    
    if ([likes count] < 1) {
        return;
    }

    for (id<SocializeLike> like in likes) {
        if(like.user.objectID == self.socialize.authenticatedUser.objectID) {
            // Found existing like for authenticated user
            self.entityLike = like;
            [(SocializeActionView*)self.view updateLikesCount:[NSNumber numberWithInt:like.entity.likes] liked:YES];
            return;
        }
    }
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    if ([service isKindOfClass:[SocializeLikeService class]]) {
        [self finishedGettingLikes:dataArray];
    } else if ([service isKindOfClass:[SocializeEntityService class]]) {
        [self finishedGettingEntities:dataArray];
    }
}

- (void)finishedDeletingLike:(id<SocializeLike>)like {
    [(SocializeActionView*)self.view updateLikesCount:[NSNumber numberWithInt:self.entityLike.entity.likes-1] liked:NO];
    self.entityLike = nil;
    [(SocializeActionView*)self.view unlockButtons];
}

-(void)service:(SocializeService *)service didDelete:(id<SocializeObject>)object
{
    if([service isKindOfClass:[SocializeLikeService class]]) {
        [self finishedDeletingLike:(id<SocializeLike>)object];
    }
}

- (void)finishedCreatingView:(id<SocializeView>)view {
    self.entityView = view;
    [(SocializeActionView*)self.view updateViewsCount:[NSNumber numberWithInt:view.entity.views]];
}

- (void)finishedCreatingLike:(id<SocializeLike>)like {
    self.entityLike = like;
    [(SocializeActionView*)self.view updateLikesCount:[NSNumber numberWithInt:like.entity.likes] liked:YES];
    [(SocializeActionView*)self.view unlockButtons];    
    
#if 0
    if ([self.socialize isAuthenticatedWithFacebook]) {
        [self sendActivityToFacebookFeed:like];            
    }
#endif
}

- (void)failedCreatingLikeWithError:(NSError*)error {
    [(SocializeActionView*)self.view unlockButtons];    
}

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object
{
    if ([object conformsToProtocol:@protocol(SocializeView)]) {
        [self finishedCreatingView:(id<SocializeView>)object];
    } else if ([object conformsToProtocol:@protocol(SocializeLike)]) {
        [self finishedCreatingLike:(id<SocializeLike>)object];
    } 
    
    [self reloadEntity];
}

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    [(SocializeActionView*)self.view updateCountsWithViewsCount:[NSNumber numberWithInt:0] withLikesCount:[NSNumber numberWithInt:0] isLiked:NO withCommentsCount:[NSNumber numberWithInt:0]];
    if([service isKindOfClass:[SocializeLikeService class]]) {
        [self failedCreatingLikeWithError:error];
    }
    
    if(![[error localizedDescription] isEqualToString:@"Entity does not exist."]) {
        [super service:service didFail:error];
    }
}

-(void)didAuthenticate:(id<SocializeUser>)user
{
    [super didAuthenticate:user];
    //remove like status because we do not know it for new user yet.
    self.entityLike = nil;
    [(SocializeActionView*)self.view updateIsLiked:NO];
}



@end
