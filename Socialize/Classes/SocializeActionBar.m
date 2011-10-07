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
#import "SocializeCommentsTableViewController.h"
#import "UIButton+Socialize.h"
#import "UINavigationBarBackground.h"
#import "SocializeView.h"
#import "SocializeEntity.h"

#define ACTION_PANE_HEIGHT 44

@implementation SocializeActionBar

@synthesize parentViewController;

+(SocializeActionBar*)createWithParentController:(UIViewController*)parentController andUrl: (NSString*)url
{
    SocializeActionBar* bar = [[[SocializeActionBar alloc] initWithParantViewSize:parentController.view.bounds.size andEntiryUrl:url] autorelease];
    [parentController.view addSubview:bar.view];
    bar.parentViewController = parentController;
    return bar;
}

-(id)initWithParantViewSize:(CGSize)parentViewSize andEntiryUrl:(NSString*)url
{
    self = [super init];
    if(self)
    {
        viewRect = CGRectMake(0, parentViewSize.height - ACTION_PANE_HEIGHT, parentViewSize.width,  ACTION_PANE_HEIGHT);
        entity = [[self.socialize createObjectForProtocol:@protocol(SocializeEntity)] retain];
        [entity setKey:url];
    }
    return self;
}

-(id)initWithParantViewSize:(CGSize)parentViewSize andEntiry:(id<SocializeEntity>)socEntity
{
    self = [super init];
    if(self)
    {
        viewRect = CGRectMake(0, parentViewSize.height - ACTION_PANE_HEIGHT, parentViewSize.width,  ACTION_PANE_HEIGHT);
        entity = [socEntity retain];
    }
    return self;
}

- (void)dealloc
{
    [entity release];
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
    SocializeActionView* actionView = [[SocializeActionView alloc] initWithFrame:viewRect];
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
            [entity release];
            entity = [(id<SocializeEntity>)object retain];          
            [(SocializeActionView*)self.view updateCountsWithViewsCount:[NSNumber numberWithInt:entity.views] withLikesCount:[NSNumber numberWithInt:entity.likes] isLiked:NO withCommentsCount:[NSNumber numberWithInt:entity.comments]];
            

        }
    }    
}

-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object
{
    if([object conformsToProtocol:@protocol(SocializeView)])
    {
        entityView = [(id<SocializeView>)object retain];
        [(SocializeActionView*)self.view updateViewsCount:[NSNumber numberWithInt:entityView.entity.views]];
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
    }
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
    [self.socialize getEntityByKey:[entity key]];
    if(entityView == nil)
        [self.socialize viewEntity:entity longitude:nil latitude:nil];
}

#pragma Socialize Action view delefate

-(void)commentButtonTouched:(id)sender
{
    [self.parentViewController presentModalViewController:comentsNavController animated:YES];
}

-(void)likeButtonTouched:(id)sender
{
    
}

@end
