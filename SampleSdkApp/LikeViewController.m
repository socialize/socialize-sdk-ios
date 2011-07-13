//
//  LikeViewController.m
//  SocializeSDK
//
//  Created by Fawad Haider on 7/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "LikeViewController.h"
#import "Socialize.h"
#import "SocializeLike.h"


@implementation LikeViewController
@synthesize entityEntryField = _entityEntryField, likeBtn = _likeBtn , socialize = _socialize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.socialize = [[Socialize alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    self.socialize = nil;
    self.entityEntryField = nil;
    self.likeBtn = nil;
    [_like release]; _like = nil; 
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)buttonTouched:(id)sender{
    if (_like)
        [self.socialize unlikeEntity:_like];
    else
        [self.socialize likeEntityWithKey:_entityEntryField.text];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.entityEntryField  = nil;
    self.likeBtn = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


#pragma mark - Socialize Service delegate

-(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    [self.likeBtn setTitle:@"Like" forState:UIControlStateNormal];
    [self.likeBtn setTitle:@"Like" forState:UIControlStateHighlighted];
    [_like release] ; _like = nil;
}

-(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    
}

-(void)service:(SocializeService*)service didFail:(NSError*)error{
    DLog(@"%@", error);
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error occurred" message:@"Like service failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

-(void)service:(SocializeService*)service didCreateWithElements:(NSArray*)dataArray andErrorList:(id)errorList{
    if (dataArray && [dataArray count]){
        // we have some data
        [self.likeBtn setTitle:@"Unlike" forState:UIControlStateNormal];
        [self.likeBtn setTitle:@"Unlike" forState:UIControlStateHighlighted];
        if ([[dataArray objectAtIndex:0]  conformsToProtocol:@protocol(SocializeLike) ]){
            _like = [dataArray objectAtIndex:0];
            [_like  retain];
        }
    }
}

-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray andErrorList:(id)errorList{

}

@end
