//
//  ProfileViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 9/26/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "ProfileViewController.h"
#import "ImagesCache.h"

@implementation ProfileViewController
@synthesize delegate = delegate_;
@synthesize cancelButton = cancelButton_;
@synthesize saveButton = saveButton_;
@synthesize user = user_;
@synthesize nameLabel = nameLabel_;
@synthesize profileImage = profileImage_;

- (void)dealloc {
    self.cancelButton = nil;
    self.saveButton = nil;
    self.user = nil;
    self.nameLabel = nil;
    self.profileImage = nil;
    
    [super dealloc];
}

- (id)init {
    return [super initWithNibName:@"ProfileViewController" bundle:nil];
}

- (UIBarButtonItem*)cancelButton {
    if (cancelButton_ == nil) {
        cancelButton_ = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                         style:UIBarButtonItemStyleBordered
                                                        target:self action:@selector(cancelButtonPressed:)];
    }
    return cancelButton_;
}

- (UIBarButtonItem*)saveButton {
    if (saveButton_ == nil) {
        saveButton_ = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                         style:UIBarButtonItemStyleBordered
                                                        target:self action:@selector(saveButtonPressed:)];
    }
    return saveButton_;
}

- (void)saveButtonPressed:(UIBarButtonItem*)saveButton {
    [self.delegate profileViewControllerDidSave:self];
}

- (void)cancelButtonPressed:(UIBarButtonItem*)cancelButton {
    [self.delegate profileViewControllerDidCancel:self];
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
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.saveButton;

    if (self.user != nil) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
        
        NSString *url = self.user.smallImageUrl;
        
        if (url != nil) {
            UIImage *existing = [[ImagesCache sharedImagesCache] imageFromCache:url];
            if (existing) {
                self.profileImage.image = existing;
            } else {
                CompleteBlock complete = [[^(ImagesCache* imgs){
                    self.profileImage.image = [imgs imageFromCache:url];
                }copy] autorelease];
                
                [[ImagesCache sharedImagesCache] loadImageFromUrl:url
                                                   completeAction:complete];
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.cancelButton = nil;
    self.saveButton = nil;
    self.nameLabel = nil;
    self.profileImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
