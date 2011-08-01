//
//  TestLikeViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestLikeViewController.h"
#import "SocializeLike.h"

#define SUCCESS @"success"
#define FAIL @"fail"

@interface TestLikeViewController()
    -(id<SocializeLike>) isLiked: (NSString*) entityKey;
@end
    
@implementation TestLikeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _socialize = [[Socialize alloc ] initWithDelegate:self]; 
        _likes = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

- (void)dealloc
{
    [_socialize release];
    [_likes release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    resultsView.hidden = YES;
    // Do any additional setup after loading the view from its nib.
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

-(id<SocializeLike>) isLiked: (NSString*) entityKey
{
    for(id likeObj in _likes)
    {
        if([[[likeObj entity] key] isEqualToString: entityKey])
        {
            return likeObj;
        }
    }
    
    return nil;
}

#pragma mark IBActions

-(IBAction)toggleLike{
    id<SocializeLike> like = [self isLiked: entityTextField.text];
    if(!like)
    {
        _loadingView = [LoadingView loadingViewInView:self.view]; 
        [_socialize likeEntityWithKey:entityTextField.text longitude:nil latitude:nil];
    }
}

-(IBAction)toggleUnlike
{
    id<SocializeLike> like = [self isLiked: entityTextField.text];
    if(like)
        [_socialize unlikeEntity:like];    
}

#pragma socialize service delegate
// for example unlike would result in this callback
-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    [entityTextField resignFirstResponder];
    [_loadingView removeView]; _loadingView = nil; 
    successLabel.text = FAIL;
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"no entity found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
    
    // setting up labels
}

-(IBAction)backgroundTouched{
    [entityTextField resignFirstResponder];
}


-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    [entityTextField resignFirstResponder];
    
    [_likes removeObject:[self isLiked:entityTextField.text]];
    [_socialize getEntityByKey:entityTextField.text];
    
    [_loadingView removeView]; _loadingView = nil;
}

// getting/retrieving comments or likes would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    [entityTextField resignFirstResponder];
    [_loadingView removeView]; _loadingView = nil;
    
    // we have to verify the contents are of type SocializeEntity 
    if ([object conformsToProtocol:@protocol(SocializeLike)]){
        id<SocializeLike> like = (id<SocializeLike>)object;
        successLabel.text = SUCCESS;
        resultsView.hidden = NO;
        keyLabel.text = like.entity.key;
        nameLabel.text = like.entity.name;
        commentsLabel.text = [NSString stringWithFormat:@"%d", like.entity.comments];
        likesLabel.text = [NSString stringWithFormat:@"%d", like.entity.likes];
        sharesLabel.text = [NSString stringWithFormat:@"%d", like.entity.shares];
        [_likes addObject:[like retain]];
    }else if([object conformsToProtocol:@protocol(SocializeEntity)])
    {
        id<SocializeEntity> entity = (id<SocializeEntity>)object;
        successLabel.text = SUCCESS;
        resultsView.hidden = NO;
        keyLabel.text = entity.key;
        nameLabel.text = entity.name;
        commentsLabel.text = [NSString stringWithFormat:@"%d", entity.comments];
        likesLabel.text = [NSString stringWithFormat:@"%d", entity.likes];
        sharesLabel.text = [NSString stringWithFormat:@"%d", entity.shares];
    }
    else{
        resultsView.hidden = YES;
        successLabel.text = FAIL;
    }
}

// getting/retrieving comments or likes would invoke this callback
-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray
{
    [entityTextField resignFirstResponder];
    [_loadingView removeView]; _loadingView = nil;
    
    if([[dataArray objectAtIndex:0] conformsToProtocol:@protocol(SocializeEntity)])
    {
        id<SocializeEntity> entity = (id<SocializeEntity>)[dataArray objectAtIndex:0];
        successLabel.text = SUCCESS;
        resultsView.hidden = NO;
        keyLabel.text = entity.key;
        nameLabel.text = entity.name;
        commentsLabel.text = [NSString stringWithFormat:@"%d", entity.comments];
        likesLabel.text = [NSString stringWithFormat:@"%d", entity.likes];
        sharesLabel.text = [NSString stringWithFormat:@"%d", entity.shares];
    }
    else{
        resultsView.hidden = YES;
        successLabel.text = FAIL;
    }

}

@end
