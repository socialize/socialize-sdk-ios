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

@interface SocializeActionBar()
@property (nonatomic, retain) id<SocializeView> entityView;
@property (nonatomic, retain) id<SocializeLike> entityLike;
@property (nonatomic, assign) BOOL finishedAskingServerForExistingLike;

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

- (void)dealloc
{
    self.presentModalInViewController = nil;
    self.entity = nil;
    self.entityLike = nil;
    self.entityView = nil;
    self.shareActionSheet = nil;
    self.shareComposer = nil;
    self.commentsNavController = nil;

    if (self.isViewLoaded) {
        [(SocializeActionView*)self.view setDelegate: nil];
    }
    
    [super dealloc];
}


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
        self.presentModalInViewController = controller;
    }
    return self;
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    SocializeActionView* actionView = [[SocializeActionView alloc] initWithFrame:CGRectMake(0, 0, 320, ACTION_PANE_HEIGHT)];
    self.view = actionView;
    actionView.delegate = self;
    [actionView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.commentsNavController = [SocializeCommentsTableViewController socializeCommentsTableViewControllerForEntity:self.entity.key];
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

- (void)afterAnonymouslyLoginAction {
    [self appear];
}

-(void)socializeActionViewWillAppear:(SocializeActionView *)socializeActionView {
    if (![self.socialize isAuthenticated]) {
        [self performAutoAuth];
    } else {
        [self appear];
    }
}

-(void)socializeActionViewWillDisappear:(SocializeActionView *)socializeActionView {
}

#pragma Socialize Action view delefate

-(void)commentButtonTouched:(id)sender
{
    self.ignoreNextView = YES;
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

- (UIActionSheet*)shareActionSheet {
    if (shareActionSheet_ == nil) {
        shareActionSheet_ = [[UIActionSheet sheetWithTitle:nil] retain];
        
        if([self.socialize facebookAvailable])
            [shareActionSheet_ addButtonWithTitle:@"Share on Facebook" handler:^{ [self shareViaFacebook]; }];

        [shareActionSheet_ addButtonWithTitle:@"Share via Email" handler:^{ [self shareViaEmail]; }];
        
        [shareActionSheet_ setCancelButtonWithTitle:nil handler:^{ NSLog(@"Never mind, then!"); }];
    }
    return shareActionSheet_;
}

-(void)shareButtonTouched: (id) sender
{    
    [self.shareActionSheet showInView:self.view.window];
}

-(void)shareViaFacebook
{
    self.ignoreNextView = YES;
    UINavigationController *shareController = [SocializePostShareViewController postShareViewControllerInNavigationControllerWithEntityURL:self.entity.key];
    [self.presentModalInViewController presentModalViewController:shareController animated:YES];
}

#pragma mark Share via email

-(void) shareViaEmail
{
    [self displayComposerSheet];
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
    
    if ([self.socialize isAuthenticatedWithFacebook]) {
        [self sendActivityToFacebookFeed:like];            
    }
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
