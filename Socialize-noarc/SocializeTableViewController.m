//
//  SocializePaginatedTableViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeTableViewController.h"
#import "SocializeTableBGInfoView.h"

NSInteger SocializeTableViewControllerDefaultPageSize = 20;

@interface SocializeTableViewController ()
@property (nonatomic, assign) BOOL waitingForContent;
@property (nonatomic, assign) BOOL loadedAllContent;
@property (nonatomic, assign, getter=isInitialized) BOOL initialized;
- (void)startLoadingContent;
- (NSArray*)indexPathsForSectionRange:(NSRange)sectionRange rowRange:(NSRange)rowRange;
@end


@implementation SocializeTableViewController
@synthesize content = content_;
@synthesize waitingForContent = waitingForActivity_;
@synthesize loadedAllContent = loadedAllActivity_;
@synthesize tableFooterView = tableFooterView_;
@synthesize tableBackgroundView = tableBackgroundView_;
@synthesize activityLoadingActivityIndicatorView = activityLoadingActivityIndicatorView_;
@synthesize activityLoadingLabel = activityLoadingLabel_;
@synthesize pageSize = pageSize_;
@synthesize informationView = informationView_;
@synthesize initialized = initialized_;

- (void)dealloc {
    self.content = nil;
    self.tableFooterView = nil;
    self.tableBackgroundView = nil;
    self.activityLoadingActivityIndicatorView = nil;
    self.activityLoadingLabel = nil;
    self.informationView = nil;
    
    [super dealloc];
}

- (void)commonInit {
    self.pageSize = SocializeTableViewControllerDefaultPageSize;
    
    // Get some defaults, even if we are subclassed
    [self.bundle loadNibNamed:@"SocializeTableViewController" owner:self options:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tableFooterView = nil;
    self.tableBackgroundView = nil;
    self.activityLoadingActivityIndicatorView = nil;
    self.activityLoadingLabel = nil;
    self.informationView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = self.tableBackgroundView;

    [self.tableView addSubview:self.informationView];
}

- (void)configureInformationView {
    
    if ([self.content count] == 0 && self.loadedAllContent) {
        // This is hidden if we are all done loading and have received nothing
        self.informationView.hidden = NO;
    } else {
        // Otherwise, it is shown
        self.informationView.hidden = YES;
    }
}

- (void)configureTableFooterView {
    if (self.loadedAllContent) {
        // If we are done loading content, we no longer need the 'loading' footer
        self.tableView.tableFooterView = nil;
    } else {
        // Otherwise we still need it shown
        self.tableView.tableFooterView = self.tableFooterView;
    }
}

- (void)contentChanged {
    [self configureTableFooterView];
    [self configureInformationView];
}

- (void)initializeContent {
    if (!self.initialized && !self.waitingForContent) {
        self.tableView.tableFooterView = self.tableFooterView;
        [self startLoadingContent];
    }
}

- (SocializeTableBGInfoView*)informationView {
    if (informationView_ == nil) {
        
        CGRect containerFrame = CGRectMake(0, 0, SocializeTableBGInfoViewDefaultWidth, SocializeTableBGInfoViewDefaultHeight);
        informationView_ = [[SocializeTableBGInfoView alloc] initWithFrame:containerFrame bgImageName:@"socialize-nocomments-icon.png"];
        CGRect tableFrame = self.tableView.frame;
        informationView_.errorLabel.hidden = NO;
        informationView_.hidden = YES;
        informationView_.errorLabel.text = @"No Content to Show.";
        CGPoint center = CGPointMake(tableFrame.size.width / 2.0, tableFrame.size.height / 2.0);
        informationView_.center = center;
        informationView_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return informationView_;
}

- (NSMutableArray*)content {
    if (content_ == nil) {
        content_ = [[NSMutableArray alloc] init];
    }
    return content_;
}

- (void)insertContentAtHead:(NSArray*)array {
    NSMutableArray *newArray = [[array mutableCopy] autorelease];
    [newArray addObjectsFromArray:self.content];
    NSInteger nElements = [array count];
    NSArray *indexPaths = [self indexPathsForSectionRange:NSMakeRange(0, 1) rowRange:NSMakeRange(0, nElements)];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    self.content = newArray;
    [self.tableView endUpdates];
    
    [self contentChanged];
}

- (void)loadContentForNextPageAtOffset:(NSInteger)offset {
    
}

- (void)startLoadingContent {
    if (self.loadedAllContent == YES) {
        return;
    }
    
    [self.activityLoadingActivityIndicatorView startAnimating];
    self.activityLoadingLabel.hidden = NO;
    self.waitingForContent = YES;
    NSInteger offset = [self.content count];
    [self loadContentForNextPageAtOffset:offset];
}

- (void)stopLoadingContent {
    [self.activityLoadingActivityIndicatorView stopAnimating];
    self.activityLoadingLabel.hidden = YES;
    self.waitingForContent = NO;
}

- (void)failLoadingContent {
    [self stopLoadingContent];
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
    
    BOOL animated = [self isViewLoaded] && self.view.window != nil;
    
    if ([content count] > 0) {
        
        if (animated) {
            [self.tableView beginUpdates];
            NSRange rowRange = NSMakeRange([self.content count], [content count]);
            NSArray *paths = [self indexPathsForSectionRange:NSMakeRange(0, 1) rowRange:rowRange];
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.content addObjectsFromArray:content];
            [self.tableView endUpdates];
        } else {
            [self.content addObjectsFromArray:content];
            
            if ([self isViewLoaded]) {
                [self.tableView reloadData];
            }
        }
    }
    
    if ([content count] < self.pageSize || [content count] == 0) {
        self.loadedAllContent = YES;
    }
    
    if (!self.initialized) {
        self.initialized = YES;
    }
    
    [self contentChanged];
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

- (void)scrollToTop {
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
