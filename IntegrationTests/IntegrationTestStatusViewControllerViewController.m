//
//  IntegrationTestStatusViewControllerViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 4/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "IntegrationTestStatusViewControllerViewController.h"
#import <Socialize/Socialize.h>
#import "integrationtests_globals.h"
#import <SZBlocksKit/BlocksKit.h>

@interface IntegrationTestStatusViewControllerViewController ()

@end

@implementation IntegrationTestStatusViewControllerViewController
@synthesize testRunner = testRunner_;
@synthesize activityIndicator = activityIndicator_;
@synthesize textView = textView_;
@synthesize statusLabel = statusLabel_;
@synthesize socialize = socialize_;
@synthesize timer = timer_;
@synthesize failedTests = failedTests_;

- (void)dealloc {
    self.activityIndicator = nil;
    self.textView = nil;
    self.socialize = nil;
    self.failedTests = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:10 * 60
                                                          block:^(NSTimer *timer) {
                                                              [self startTestsIfNeeded];
                                                          }
                                                        repeats:YES];
    }
    
    return self;
}

- (NSMutableArray*)failedTests {
    if (failedTests_ == nil) {
        failedTests_ = [[NSMutableArray alloc] init];
    }
    
    return failedTests_;
}

- (NSArray*)failedTestNames {
    NSMutableArray *names = [NSMutableArray array];
    for (id<GHTest> test in self.failedTests) {
        [names addObject:[test identifier]];
    }
    return names;
}

- (GHTestRunner*)testRunner {
    if (testRunner_ == nil) {
        testRunner_ = [[GHTestRunner runnerFromEnv] retain];
        testRunner_.delegate = self;
    }
    
    return testRunner_;
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    return socialize_;
}

- (void)updateStatusForRunner:(GHTestRunner*)runner {
    GHTestStats stats = [runner stats];
    
    self.statusLabel.text = [NSString stringWithFormat:@"%d/%d", stats.succeedCount, stats.testCount];
    
    if (stats.failureCount > 0) {
        self.statusLabel.textColor = [UIColor redColor];        
    } else {
        self.statusLabel.textColor = [UIColor greenColor];
    }
}

- (void)testRunnerDidStart:(GHTestRunner *)runner {
    self.failedTests = nil;
    [self updateStatusForRunner:runner];
    [self.activityIndicator startAnimating];
}

- (void)testRunnerDidEnd:(GHTestRunner *)runner {
    [self.activityIndicator stopAnimating];
    
    GHTestStats stats = [runner stats];
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [values setObject:[NSNumber numberWithInt:stats.testCount] forKey:@"testCount"];
    [values setObject:[NSNumber numberWithInt:stats.failureCount] forKey:@"failureCount"];
    NSString *failedTestNames = [[self failedTestNames] componentsJoinedByString:@","];
    [values setObject:failedTestNames forKey:@"failedTests"];

    if (stats.succeedCount == stats.testCount) {
        [self.socialize trackEventWithBucket:@"ITEST_SUCCESS" values:values];
    } else {
        [self.socialize trackEventWithBucket:@"ITEST_FAILURE" values:values];        
    }
}

- (void)testRunner:(GHTestRunner *)runner didEndTest:(id<GHTest>)test {
    [self updateStatusForRunner:runner];
    
    if (test.status == GHTestStatusErrored && [test isKindOfClass:[GHTest class]]) {
        [self.failedTests addObject:test];
    }
}

- (void)viewDidLoad
{
    self.statusLabel.text = nil;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)startTestsIfNeeded {
    if (!self.testRunner.running) {
        [self.testRunner runInBackground];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTestsIfNeeded];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
