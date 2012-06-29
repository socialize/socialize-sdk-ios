//
//  URLDownload.m
//  HitFix
//
//  Created by PointAbout Developer on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "URLDownload.h"
#import "URLDownloadOperation.h"
#import "socialize_globals.h"


@interface URLDownload()
    -(void)startDownload:(NSURLConnection *)downloadConnection;
@end

@implementation URLDownload

@synthesize urlData;
@synthesize objectIdentifier;
@synthesize operation;
@synthesize urlForDownload;
@synthesize requestedObject;
@synthesize downloadQueue;


- (void) dealloc {
	self.urlForDownload = nil;
    self.objectIdentifier = nil;
    self.downloadQueue = nil;
    self.urlData = nil;
    [operation release]; operation = nil;
	[super dealloc];
}

+ (NSOperationQueue *)downloadQueue {
	
	static NSOperationQueue *downloadQueue;
	if (!downloadQueue) {
		downloadQueue = [[NSOperationQueue alloc] init];
		[downloadQueue setMaxConcurrentOperationCount:1];
	}
	return downloadQueue;
}

- (void) cancelDownload{
    @synchronized(self)
    {
        requestedObject =  nil;
        [self.downloadQueue cancelAllOperations];
    }
}

- (id) initWithURL:(NSString *)url sender:(NSObject *)caller selector:(SEL)Selector tag:(id)downloadTag 
{
    __block URLDownload* blockSelf = self;
    OperationFactoryBlock factory = ^ URLDownloadOperation* (id target, SEL method, id object)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        NSURLConnection* downloadConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:blockSelf startImmediately:NO] autorelease];
        
        return  [[[URLDownloadOperation alloc] initWithTarget:blockSelf selector:@selector(startDownload:) object:downloadConnection] autorelease];
    };
    
    return [self initWithURL:url sender:caller selector:Selector tag:downloadTag downloadQueue:[URLDownload downloadQueue] operationFactory: factory];
}

- (id) initWithURL:(NSString *)url 
            sender:(NSObject *)caller 
          selector:(SEL)Selector
               tag:(id)downloadTag 
     downloadQueue:(NSOperationQueue*)queue
    operationFactory:(OperationFactoryBlock) factoryBlock
    
{
    self = [super init];
    if(self)
    {
        self.urlForDownload = url; 
        self.objectIdentifier = downloadTag;
        self.downloadQueue = queue;
        self.requestedObject = caller;
        notificationSelector = Selector;
        
        if(factoryBlock)
            operation = [factoryBlock(self, @selector(startDownload:), url) retain];
        [self.downloadQueue addOperation:operation]; 
	}
	return self;    
}

-(void)startDownload:(NSURLConnection *)downloadConnection
{
    [downloadConnection start];
    [self runCurrentLoopForTimeInterval:[NSNumber numberWithInt:10]];
}

-(void)runCurrentLoopForTimeInterval:(NSNumber *)timeInterval {
    //this method is here so we can mock out the run loop during tests
    DebugLog(@"starting run loop for %i seconds", [timeInterval intValue]);
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:[timeInterval intValue]]];    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
    // inform the user
    DebugLog(@"Connection failed! Error - %@ %@",
	[error localizedDescription],
	[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	[self performSelectorOnMainThread:@selector(dataSendback) withObject:nil waitUntilDone:YES];
	
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// DebugLog(@"receiveing downloaded data for %i", self.objectIdentifier);
	if (!self.urlData)
		self.urlData = [[[NSMutableData alloc] init] autorelease];

	[self.urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"%@", @"OK");
	[self performSelectorOnMainThread:@selector(dataSendback) withObject:nil waitUntilDone:YES];
}

-(void)dataSendback {
    @synchronized(self)
    {
        [operation release];operation = nil;
        
        NSMethodSignature *signature;
        if ([requestedObject respondsToSelector:@selector(class)])
            signature = [[requestedObject class] instanceMethodSignatureForSelector:notificationSelector];
        else
            return;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:notificationSelector];
        [invocation setArgument:&urlData atIndex:2];
        [invocation setArgument:&self atIndex:3];
        [invocation setArgument:&objectIdentifier atIndex:4];
        [invocation setTarget:requestedObject];
        [invocation invoke];
    }
}

@end
