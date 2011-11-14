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

@interface SocializeActionBar()
@property(nonatomic, retain) id<SocializeLike> entityLike;
@property(nonatomic, retain) id<SocializeView> entityView;

-(void) shareViaEmail;
-(void)shareViaFacebook;
-(void)displayComposerSheet;

@end

@implementation SocializeActionBar

@synthesize presentModalInViewController = _presentModalInViewController;
@synthesize entity;
@synthesize entityLike;
@synthesize entityView;
@synthesize ignoreNextView = _ignoreNextView;
@synthesize shareActionSheet = _shareActionSheet;
@synthesize shareComposer = _shareComposer;

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

- (void)dealloc
{
    [entity release];
    [entityView release];
    [entityLike release];
    if (self.isViewLoaded) {
        [(SocializeActionView*)self.view setDelegate: nil];
    }
    [comentsNavController release];
    self.presentModalInViewController = nil;
    
    self.shareComposer = nil;
    
    self.shareActionSheet = nil;
    
    [super dealloc];
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

    comentsNavController = [[SocializeCommentsTableViewController socializeCommentsTableViewControllerForEntity:[entity key]] retain];
}


-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    if ([dataArray count]){
        id<SocializeObject> object = [dataArray objectAtIndex:0];
        if ([object conformsToProtocol:@protocol(SocializeEntity)])
        {
            self.entity = (id<SocializeEntity>)object;          
            [(SocializeActionView*)self.view updateCountsWithViewsCount:[NSNumber numberWithInt:entity.views] withLikesCount:[NSNumber numberWithInt:entity.likes] isLiked:entityLike!=nil withCommentsCount:[NSNumber numberWithInt:entity.comments]];
        }
        if ([object conformsToProtocol:@protocol(SocializeLike)])
        {
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                id<SocializeLike> like = (id<SocializeLike>)obj;
                if(like.user.objectID == self.socialize.authenticatedUser.objectID)
                {
                    self.entityLike = like;
                    [(SocializeActionView*)self.view updateLikesCount:[NSNumber numberWithInt:self.entityLike.entity.likes] liked:YES];
                    *stop = YES;
                }
            }];
        }
    }    
}

-(void)service:(SocializeService *)service didDelete:(id<SocializeObject>)object
{
    [(SocializeActionView*)self.view updateLikesCount:[NSNumber numberWithInt:entityLike.entity.likes-1] liked:NO];
    self.entityLike = nil;
    [(SocializeActionView*)self.view unlockButtons];
    
}

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object
{
    if([object conformsToProtocol:@protocol(SocializeView)])
    {
        self.entityView = (id<SocializeView>)object;
        [(SocializeActionView*)self.view updateViewsCount:[NSNumber numberWithInt:entityView.entity.views]];
    }
    if([object conformsToProtocol:@protocol(SocializeLike)])
    {
        self.entityLike = (id<SocializeLike>)object;
        [(SocializeActionView*)self.view updateLikesCount:[NSNumber numberWithInt:entityLike.entity.likes] liked:YES];
        [(SocializeActionView*)self.view unlockButtons];
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
    [(SocializeActionView*)self.view updateCountsWithViewsCount:[NSNumber numberWithInt:0] withLikesCount:[NSNumber numberWithInt:0] isLiked:NO withCommentsCount:[NSNumber numberWithInt:0]];
    if([service isKindOfClass:[SocializeAuthenticateService class]])
    {
        [super service:service didFail:error];
    }
    else
    {       
        if(![[error localizedDescription] isEqualToString:@"Entity does not exist."])
            [self showAllertWithText:[error localizedDescription] andTitle:@"Get entiry failed"];
        
        if([service isKindOfClass:[SocializeLikeService class]])
            [(SocializeActionView*)self.view unlockButtons];
    }
}

-(void)didAuthenticate:(id<SocializeUser>)user
{
    [super didAuthenticate:user];
    //remove like status because we do not know it for new user yet.
    self.entityLike = nil;
    [(SocializeActionView*)self.view updateIsLiked:NO];
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

-(void)socializeActionViewWillAppear:(SocializeActionView *)socializeActionView {
    [socializeActionView startActivityForUpdateViewsCount];
    [self performAutoAuth];
}

-(void)socializeActionViewWillDisappear:(SocializeActionView *)socializeActionView {
}

#pragma Socialize Action view delefate

-(void)commentButtonTouched:(id)sender
{
    self.ignoreNextView = YES;
    [self.presentModalInViewController presentModalViewController:comentsNavController animated:YES];
}

-(void)likeButtonTouched:(id)sender
{
    [(SocializeActionView*)self.view lockButtons];
    
    if(entityLike)
        [self.socialize unlikeEntity: entityLike];
    else
        [self.socialize likeEntityWithKey:[entity key] longitude:nil latitude:nil];
}

- (UIActionSheet*)shareActionSheet {
    if (_shareActionSheet == nil) {
        _shareActionSheet = [[UIActionSheet sheetWithTitle:nil] retain];
        
        if([self.socialize facebookAvailable])
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
    }
    
    return _shareComposer;
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
    NSString *emailBody = [NSString stringWithFormat: @"I thought you would find this interesting: %@ %@", entity.name, entity.key];
    [self.shareComposer setMessageBody:emailBody isHTML:NO];

	[self.presentModalInViewController presentModalViewController:self.shareComposer animated:YES];
}

@end
