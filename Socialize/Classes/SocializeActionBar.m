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
#import "SocializeShareSheetBuilder.h"
#import "BlocksKit.h"

@interface SocializeActionBar()
@property(nonatomic, retain) id<SocializeLike> entityLike;
@property(nonatomic, retain) id<SocializeView> entityView;
@end

@implementation SocializeActionBar

@synthesize parentViewController;
@synthesize entity;
@synthesize entityLike;
@synthesize entityView;
@synthesize didFetchEntity = _didFetchEntity;

+(SocializeActionBar*)createWithParentController:(UIViewController*)parentController andUrl: (NSString*)url
{
    SocializeActionBar* bar = [[[SocializeActionBar alloc] initWithEntityUrl:url] autorelease];
    bar.parentViewController = parentController;
    return bar;
}

-(id)initWithEntityUrl:(NSString*)url
{
    self = [super init];
    if(self)
    {
        self.entity = [self.socialize createObjectForProtocol:@protocol(SocializeEntity)];
        [entity setKey:url];
    }
    return self;
}

-(id)initWithEntity:(id<SocializeEntity>)socEntity
{
    self = [super init];
    if(self)
    {
        self.entity = socEntity;
    }
    return self;
}

- (void)dealloc
{
    [entity release];
    [entityView release];
    [entityLike release];
    [(SocializeActionView*)self.view setDelegate: nil];
    [comentsNavController release];
    self.parentViewController = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    SocializeActionView* actionView = [[SocializeActionView alloc] initWithFrame:CGRectZero];
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    if ([dataArray count]){
        id<SocializeObject> object = [dataArray objectAtIndex:0];
        if ([object conformsToProtocol:@protocol(SocializeEntity)])
        {
            self.entity = (id<SocializeEntity>)object;          
            [(SocializeActionView*)self.view updateCountsWithViewsCount:[NSNumber numberWithInt:entity.views] withLikesCount:[NSNumber numberWithInt:entity.likes] isLiked:entityLike!=nil withCommentsCount:[NSNumber numberWithInt:entity.comments]];
            self.didFetchEntity = YES;
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

-(void)afterAnonymouslyLoginAction
{
    if (!self.didFetchEntity) {
        [self.socialize getEntityByKey:[entity key]];
    }
    [self.socialize viewEntity:entity longitude:nil latitude:nil];

    if(entityLike == nil)
        [self.socialize getLikesForEntityKey:[entity key] first:nil last:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self.parentViewController presentModalViewController:comentsNavController animated:YES];
}

-(void)likeButtonTouched:(id)sender
{
    [(SocializeActionView*)self.view lockButtons];
    
    if(entityLike)
        [self.socialize unlikeEntity: entityLike];
    else
        [self.socialize likeEntityWithKey:[entity key] longitude:nil latitude:nil];
}

-(void)shareButtonTouched: (id) sender
{    
    UIActionSheet* shareActionSheet = [UIActionSheet sheetWithTitle:nil];
    [shareActionSheet addButtonWithTitle:@"Share on Twitter" handler:^{ NSLog(@"Zip!"); }];
    [shareActionSheet addButtonWithTitle:@"Share on Facebook" handler:^{ NSLog(@"Zap!"); }];
    [shareActionSheet addButtonWithTitle:@"Share via Email" handler:^{ NSLog(@"Zop!"); }];
    [shareActionSheet setCancelButtonWithTitle:nil handler:^{ NSLog(@"Never mind, then!"); }];
    [shareActionSheet showInView:self.view.window];
}

@end
