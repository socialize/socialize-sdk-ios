//
//  TestLikeViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/31/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "TestLikeViewController.h"
#import <Socialize/Socialize.h>
#import "UIButton+Socialize.h"

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
    self.navigationItem.title = @"Create a like/unlike";

    resultsView.hidden = YES;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [unlikeButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK]; 
    [likeButton configureWithoutResizingWithType:AMSOCIALIZE_BUTTON_TYPE_BLACK];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    hiddenButton = [[UIButton alloc] init]; 
    hiddenButton.hidden = YES;
    hiddenButton.accessibilityLabel = @"hiddenButton";
    [self.view addSubview:hiddenButton];
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
    if (!hiddenButton){
        hiddenButton = [[UIButton alloc] init]; 
        hiddenButton.hidden = YES;
        hiddenButton.accessibilityLabel = @"hiddenButton";
        [self.view addSubview:hiddenButton];
    }
    id<SocializeLike> like = [self isLiked: entityTextField.text];
    if(!like) {
        _loadingView = [SocializeLoadingView loadingViewInView:self.view/* withMessage:@"Liking"*/]; 
        [_socialize likeEntityWithKey:entityTextField.text longitude:nil latitude:nil];
    }
}

-(IBAction)toggleUnlike
{
    if (!hiddenButton){
        hiddenButton = [[UIButton alloc] init]; 
        hiddenButton.hidden = YES;
        hiddenButton.accessibilityLabel = @"hiddenButton";
        [self.view addSubview:hiddenButton];
    }

    id<SocializeLike> like = [self isLiked: entityTextField.text];
    if(like){
        _loadingView = [SocializeLoadingView loadingViewInView:self.view /*withMessage:@"unliking"*/]; 
        [_socialize unlikeEntity:like];    
    }
}

#pragma socialize service delegate
// for example unlike would result in this callback
-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;

    [entityTextField resignFirstResponder];
    [_loadingView removeView]; _loadingView = nil; 
    resultTextField.text = FAIL;
    
    UIAlertView *msg;
    msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"no entity found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

-(IBAction)backgroundTouched{
    [entityTextField resignFirstResponder];
}

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;

    [entityTextField resignFirstResponder];
    [_likes removeObject:[self isLiked:entityTextField.text]];
    [_loadingView removeView]; _loadingView = nil;
    resultsView.hidden = YES;
    unlikeButton.enabled = NO;
    resultTextField.text = SUCCESS;
    
}

// getting/retrieving comments or likes would invoke this callback
-(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{

    [hiddenButton removeFromSuperview];
    [hiddenButton release];
    hiddenButton = nil;
  
    [entityTextField resignFirstResponder];
    [_loadingView removeView]; _loadingView = nil;
    
    // we have to verify the contents are of type SocializeEntity 
    if ([object conformsToProtocol:@protocol(SocializeLike)]){

        id<SocializeLike> like = (id<SocializeLike>)object;
        resultTextField.text = SUCCESS;
        
        resultsView.hidden = NO;
        unlikeButton.enabled = YES;
        
        keyLabel.text = like.entity.key;
        nameLabel.text = like.entity.name;
        commentsLabel.text = [NSString stringWithFormat:@"%d", like.entity.comments];
        likesLabel.text = [NSString stringWithFormat:@"%d", like.entity.likes];
        sharesLabel.text = [NSString stringWithFormat:@"%d", like.entity.shares];
        [_likes addObject:like];
    }
    else{
        resultsView.hidden = YES;
        resultTextField.text = FAIL;
    }
}

@end
