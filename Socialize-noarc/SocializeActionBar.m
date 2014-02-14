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
#import "_SZCommentsListViewController.h"
#import "UIButton+Socialize.h"
#import "UINavigationBarBackground.h"
#import "SocializeView.h"
#import "SocializeEntity.h"
#import <SZBlocksKit/BlocksKit.h>
#import "SocializeFacebookInterface.h"
#import "SocializeEntityService.h"
#import "_SZUserProfileViewController.h"
#import "NSError+Socialize.h"
#import "SZNavigationController.h"
#import "SZLikeUtils.h"
#import "SZShareUtils.h"
#import "SZCommentUtils.h"
#import "SZUserProfileViewController.h"
#import "SZUserUtils.h"

@interface SocializeActionBar()
@property (nonatomic, retain) id<SocializeView> entityView;
@property (nonatomic, retain) id<SocializeLike> entityLike;
@property (nonatomic, assign) BOOL finishedAskingServerForExistingLike;
@property (nonatomic, assign) BOOL initialized;

-(void)askServerForExistingLike;
-(void)reloadEntity;
@end

@implementation SocializeActionBar

@synthesize entity = _entity;
@synthesize entityLike = entityLike_;
@synthesize entityView = entityView_;
@synthesize ignoreNextView = ignoreNextView_;
@synthesize shareActionSheet = shareActionSheet_;
@synthesize shareComposer = shareComposer_;
@synthesize finishedAskingServerForExistingLike = finishedAskingServerForExistingLike_;
@synthesize noAutoLayout = noAutoLayout_;
@synthesize initialized = initialized_;
@synthesize delegate = delegate_;
@synthesize unconfiguredEmailAlert = unconfiguredEmailAlert_;
@synthesize shareTextMessageComposer = shareTextMessageComposer_;
@synthesize viewController = viewController_;

- (void)dealloc
{
    self.entity = nil;
    self.entityLike = nil;
    self.entityView = nil;
    self.shareActionSheet = nil;
    self.shareComposer = nil;
    self.unconfiguredEmailAlert = nil;
    self.shareTextMessageComposer = nil;
    self.viewController = nil;
    
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
+(SocializeActionBar*)actionBarWithKey:(NSString*)key name:(NSString*)name presentModalInController:(UIViewController*)controller {
    return [[[SocializeActionBar alloc] initWithEntityKey:key name:name presentModalInController:controller] autorelease];
}
#pragma GCC diagnostic pop

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
    self = [super init];
    if(self)
    {
        self.entity = entity;
        self.viewController = controller;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)presentInternalController:(UIViewController*)viewController {
    self.ignoreNextView = YES;
    [self.viewController presentViewController:viewController animated:YES completion:nil];
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

#pragma mark Socialize Action view delefate

-(void)commentButtonTouched:(id)sender
{
    self.ignoreNextView = YES;
    [SZCommentUtils showCommentsListWithViewController:self.viewController entity:self.entity completion:nil];
}

-(void)likeButtonTouched:(id)sender
{
    [(SocializeActionView*)self.view lockButtons];
    
    if (self.entityLike)
        [self.socialize unlikeEntity:self.entityLike];
    else {
        self.ignoreNextView = YES;

        [SZLikeUtils likeWithViewController:self.viewController options:nil entity:self.entity success:^(id<SZLike> like) {
            [self finishedCreatingLike:like];
        } failure:^(NSError *error) {
            [(SocializeActionView*)self.view unlockButtons];

            if (![error isSocializeErrorWithCode:SocializeErrorLikeCancelledByUser]) {
                [self failedCreatingLikeWithError:error];
            }
        }];
    }
}

-(void)viewButtonTouched:(id)sender
{
    SZUserProfileViewController *profile = [[[SZUserProfileViewController alloc] initWithUser:(id<SZUser>)[SZUserUtils currentUser]] autorelease];
    profile.completionBlock = ^(id<SZFullUser> user) {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentInternalController:profile];
}

-(void)shareButtonTouched: (id) sender
{
    self.ignoreNextView = YES;
    [SZShareUtils showShareDialogWithViewController:self.viewController entity:self.entity completion:nil cancellation:nil];
}

- (void)reloadEntity {
    // Refresh from server
    [self.socialize getEntityByKey:self.entity.key];
}

- (void)updateEntity:(id<SocializeEntity>)entity {
    self.entity = entity;
    [(SocializeActionView*)self.view updateCountsWithViewsCount:[NSNumber numberWithInt:entity.views]
                                                 withLikesCount:[NSNumber numberWithInt:entity.likes]
                                                        isLiked:self.entityLike != nil
                                              withCommentsCount:[NSNumber numberWithInt:entity.comments]];    
    
    if (!self.initialized) {
        self.initialized = YES;
        [(SocializeActionView*)self.view showButtons];
    }
}

- (void)finishedGettingEntities:(NSArray*)entities {
    if ([entities count] < 1) {
        return;
    }
    
    id<SocializeEntity> entity = [entities objectAtIndex:0];
    [self updateEntity:entity];
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
}

- (void)failedCreatingLikeWithError:(NSError*)error {
    [(SocializeActionView*)self.view unlockButtons];
    
    if (![error isSocializeErrorWithCode:SocializeErrorThirdPartyLinkCancelledByUser] && ![[error localizedDescription] isEqualToString:@"Entity does not exist."]) {
        [self failWithError:error];
    }
}

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object
{
    if ([object conformsToProtocol:@protocol(SocializeView)]) {
        id<SocializeView> view = (id<SocializeView>)object;
        [self finishedCreatingView:view];
        [self updateEntity:view.entity];
    } else if ([object conformsToProtocol:@protocol(SocializeLike)]) {
        id<SocializeLike> like = (id<SocializeLike>)object;
        [self finishedCreatingLike:like];
        [self updateEntity:like.entity];
    } 
}

-(void)service:(SocializeService*)service didFail:(NSError*)error
{
    [(SocializeActionView*)self.view updateCountsWithViewsCount:[NSNumber numberWithInt:0] withLikesCount:[NSNumber numberWithInt:0] isLiked:NO withCommentsCount:[NSNumber numberWithInt:0]];
    if([service isKindOfClass:[SocializeLikeService class]]) {
        [self failedCreatingLikeWithError:error];
    } else {
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
