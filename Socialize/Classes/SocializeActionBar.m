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
#import "SocializeUIShareOptions.h"
#import "NSError+Socialize.h"
#import "SocializeUIDisplayProxy.h"
#import "SocializeUIShareCreator.h"
#import "SocializeLikeCreator.h"

@interface SocializeActionBar()
@property (nonatomic, retain) id<SocializeView> entityView;
@property (nonatomic, retain) id<SocializeLike> entityLike;
@property (nonatomic, assign) BOOL finishedAskingServerForExistingLike;
@property (nonatomic, assign) BOOL initialized;

-(void)askServerForExistingLike;
-(void)reloadEntity;
@end

@implementation SocializeActionBar

@synthesize displayProxy = _display;
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
@synthesize shareTextMessageComposer = shareTextMessageComposer_;

- (void)dealloc
{
    self.displayProxy = nil;
    self.entity = nil;
    self.entityLike = nil;
    self.entityView = nil;
    self.shareActionSheet = nil;
    self.shareComposer = nil;
    self.commentsNavController = nil;
    self.unconfiguredEmailAlert = nil;
    self.shareTextMessageComposer = nil;
    
    if (self.isViewLoaded) {
        [(SocializeActionView*)self.view setDelegate: nil];
    }
    
    [super dealloc];
}


+(SocializeActionBar*)actionBarWithKey:(NSString*)url presentModalInController:(UIViewController*)controller
{
    return [self actionBarWithKey:url name:nil presentModalInController:controller];
}

+(SocializeActionBar*)actionBarWithUrl:(NSString*)url presentModalInController:(UIViewController*)controller {
    return [self actionBarWithKey:url presentModalInController:controller];
}

+(SocializeActionBar*)actionBarWithKey:(NSString*)key name:(NSString*)name presentModalInController:(UIViewController*)controller {
    return [[[SocializeActionBar alloc] initWithEntityKey:key name:name presentModalInController:controller] autorelease];
}

+(SocializeActionBar*)actionBarWithEntity:(id<SocializeEntity>)entity display:(id)display {
    return [[[SocializeActionBar alloc] initWithEntity:entity display:display] autorelease];
}

-(id)initWithEntityKey:(NSString*)key name:(NSString*)name presentModalInController:(UIViewController*)controller {
    id<SocializeEntity> newEntity = [self.socialize createObjectForProtocol:@protocol(SocializeEntity)];
    [newEntity setKey:key];
    [newEntity setName:name];
    return [self initWithEntity:newEntity presentModalInController:controller];
}

-(id)initWithEntityKey:(NSString*)key presentModalInController:(UIViewController*)controller
{
    return [self initWithEntityKey:key name:nil presentModalInController:controller];
}

-(id)initWithEntityUrl:(NSString*)url presentModalInController:(UIViewController*)controller {
    return [self initWithEntityKey:url presentModalInController:controller];
}

-(id)initWithEntity:(id<SocializeEntity>)entity presentModalInController:(UIViewController*)controller {
    return [self initWithEntity:entity display:controller];
}

-(id)initWithEntity:(id<SocializeEntity>)entity display:(id)display {
    self = [super init];
    if(self)
    {
        self.entity = entity;
        self.displayProxy = [SocializeUIDisplayProxy UIDisplayProxyWithObject:self display:display];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)presentInternalController:(UIViewController*)viewController {
    [self.displayProxy presentModalViewController:viewController];
}

- (void)displayProxy:(SocializeUIDisplayProxy *)proxy willDisplayViewController:(UIViewController *)controller {
    self.ignoreNextView = YES;
}

- (BOOL)displayProxy:(SocializeUIDisplayProxy *)proxy shouldDisplayActionSheet:(UIActionSheet *)actionSheet {
    if ([self.delegate respondsToSelector:@selector(actionBar:wantsDisplayActionSheet:)]) {
        [self.delegate actionBar:self wantsDisplayActionSheet:actionSheet];
        return NO;
    }
    return YES;
}

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

- (void)afterLoginAction:(BOOL)userChanged {
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
    // Reset for now, since we yet don't have refresh functionality
    self.commentsNavController = nil;
    
    [self presentInternalController:self.commentsNavController];
}

-(void)likeButtonTouched:(id)sender
{
    [(SocializeActionView*)self.view lockButtons];
    
    if(self.entityLike)
        [self.socialize unlikeEntity:self.entityLike];
    else {
        SocializeLike *like = [SocializeLike likeWithEntity:self.entity];
        __block __typeof__(self) weakSelf = self;
        [SocializeLikeCreator createLike:like
                                 options:nil
                                 displayProxy:self.displayProxy
                                 success:^(id<SocializeLike> serverLike) {
                                     [weakSelf finishedCreatingLike:serverLike];
                                 } failure:^(NSError *error) {
                                     [weakSelf failedCreatingLikeWithError:error];
                                 }];
    }
}

-(void)viewButtonTouched:(id)sender
{
    UINavigationController *nav = [SocializeProfileViewController currentUserProfileWithDelegate:nil];
    [self presentInternalController:nav];
}

-(void)shareButtonTouched: (id) sender
{
    SocializeUIShareOptions *options = [SocializeUIShareOptions UIShareOptionsWithEntity:self.entity];
    [SocializeUIShareCreator createShareWithOptions:options
                                       displayProxy:self.displayProxy
                                            success:^{}
                                            failure:^(NSError *error) {
                                                if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                                                    [self showAlertWithText:[error localizedDescription] andTitle:@"Share Failed"];
                                                }
                                            }];
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
