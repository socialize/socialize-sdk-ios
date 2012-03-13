/*
 * TestSocializeActionBar.m
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

#import "TestSocializeActionBar.h"
#import  <Socialize/Socialize.h>

@implementation TestSocializeActionBar
@synthesize entityView;
@synthesize entityUrl;

-(id) initWithEntityUrl:(NSString*)url
{
    self = [super init];
    if(self)
    {
        self.entityUrl = url;
    }
    return self;
}

- (void)dealloc
{
    [entityView release];
    [entityUrl release];
    [bar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.entityView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.entityUrl]]];
//    bar = [[SocializeActionBar actionBarWithKey:self.entityUrl name:@"TestBar" presentModalInController:self] retain];
    SocializeEntity *entity = [[[SocializeEntity alloc] init] autorelease];
    entity.key = self.entityUrl;
    entity.name = @"TestBar";
    bar = [[SocializeActionBar actionBarWithKey:self.entityUrl name:@"TestBar" presentModalInController:self] retain];
    bar.delegate = self;
//    bar.view.frame = CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
    [self.view addSubview:bar.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.entityView = nil;
    [bar release]; bar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

//- (void)actionBar:(SocializeActionBar *)actionBar wantsDisplayActionSheet:(UIActionSheet *)actionSheet {
////    NSLog(@"Hi there");
//}

@end
