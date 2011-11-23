//
//  SocializePaginatedTableViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeTableViewController.h"
#import "SocializeTableBGInfoView.h"

NSInteger SocializeTableViewControllerDefaultPageSize = 10;

@interface SocializeTableViewController ()
@property (nonatomic, assign) BOOL waitingForContent;
@property (nonatomic, assign) BOOL loadedAllContent;
@end


@implementation SocializeTableViewController
@synthesize content = content_;
@synthesize waitingForContent = waitingForActivity_;
@synthesize loadedAllContent = loadedAllActivity_;
@synthesize tableFooterView = tableFooterView_;
@synthesize tableBackgroundView = tableBackgroundView_;
@synthesize activityLoadingActivityIndicatorView = activityLoadingActivityIndicatorView_;
@synthesize pageSize = pageSize_;
@synthesize informationView = informationView_;

- (void)dealloc {
    self.content = nil;
    self.tableFooterView = nil;
    self.tableBackgroundView = nil;
    self.activityLoadingActivityIndicatorView = nil;
    self.informationView = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.pageSize = SocializeTableViewControllerDefaultPageSize;
        
        // Get some defaults, even if we are subclassed
        [self.bundle loadNibNamed:@"SocializeTableViewController" owner:self options:nil];
    }
    return self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tableFooterView = nil;
    self.tableBackgroundView = nil;
    self.activityLoadingActivityIndicatorView = nil;
    self.informationView = nil;
}

- (UIView*)tableBackgroundView {
    if (tableBackgroundView_ == nil) {
        tableBackgroundView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_brushed_metal@2x.png"]];
    }
    return tableBackgroundView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = self.tableBackgroundView;
    self.tableView.tableFooterView = self.tableFooterView;
    
    [self.tableView addSubview:self.informationView];
}

- (SocializeTableBGInfoView*)informationView {
    if (informationView_ == nil) {
        
        CGRect containerFrame = CGRectMake(0, 0, SocializeTableBGInfoViewDefaultWidth, SocializeTableBGInfoViewDefaultHeight);
        informationView_ = [[SocializeTableBGInfoView alloc] initWithFrame:containerFrame bgImageName:@"socialize-nocomments-icon.png"];
        CGRect tableFrame = self.tableView.frame;
        CGPoint center = CGPointMake(tableFrame.size.width / 2.0, tableFrame.size.height / 2.0);
        self.informationView.errorLabel.hidden = NO;
        self.informationView.noActivityImageView.hidden = NO;
        informationView_.hidden = YES;
        informationView_.errorLabel.text = @"No Content to Show.";
        informationView_.center = center;
    }
    return informationView_;
}

- (NSMutableArray*)content {
    if (content_ == nil) {
        content_ = [[NSMutableArray alloc] init];
    }
    return content_;
}

- (void)loadContentForNextPageAtOffset:(NSInteger)offset {
    
}

- (void)startLoadingContent {
    [self.activityLoadingActivityIndicatorView startAnimating];
    self.waitingForContent = YES;
    NSInteger offset = [self.content count];
    [self loadContentForNextPageAtOffset:offset];
}

- (void)stopLoadingContent {
    [self.activityLoadingActivityIndicatorView stopAnimating];
    self.waitingForContent = NO;
}

- (NSArray*)indexPathsForSectionRange:(NSRange)sectionRange rowRange:(NSRange)rowRange {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:sectionRange.length*rowRange.length];
    for (int s = sectionRange.location; s < sectionRange.location + sectionRange.length; s++) {
        for (int r = rowRange.location; r < rowRange.location + rowRange.length; r++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:r inSection:s]];
        }
    }
    return indexPaths;
}

- (void)receiveNewContent:(NSArray*)content {
    [self stopLoadingContent];
    
    if ([content count] > 0) {
        [self.tableView beginUpdates];
        NSRange rowRange = NSMakeRange([self.content count], [content count]);
        NSArray *paths = [self indexPathsForSectionRange:NSMakeRange(0, 1) rowRange:rowRange];
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.content addObjectsFromArray:content];
        [self.tableView endUpdates];
    }
    
    if ([content count] < self.pageSize) {
        self.loadedAllContent = YES;
    }
    
    if ([self.content count] == 0) {
        self.tableFooterView.hidden = YES;
        self.informationView.hidden = NO;
    } else {
        self.informationView.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
    
    CGFloat offset = scrollView.contentOffset.y + scrollView.bounds.size.height;
    if (offset >= scrollView.contentSize.height && !self.waitingForContent && !self.loadedAllContent) {
        [self startLoadingContent];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.content count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
