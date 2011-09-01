//
//  URLDownload.m
//  HitFix
//
//  Created by PointAbout Developer on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "URLDownload.h"
#import "URLDownloadOperation.h"
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
    [operation release]; operation = nil;
    [urlData release]; operation = nil;
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

- (id) initWithURL:(NSString *)url sender:(NSObject *)caller selector:(SEL)Selector tag:(NSObject *)downloadTag 
{
    return [self initWithURL:url sender:caller selector:Selector tag:downloadTag downloadQueue:[URLDownload downloadQueue]];
}

- (id) initWithURL:(NSString *)url sender:(NSObject *)caller selector:(SEL)Selector tag:(NSObject *)downloadTag downloadQueue:(NSOperationQueue*)queue
{
    self = [super init];
    if(self)
    {
        self.urlForDownload = url; 
        requestedObject = caller;
        notificationSelector = Selector;
        self.objectIdentifier = downloadTag;
	
        operation = [[URLDownloadOperation alloc] initWithTarget:self selector:@selector(startDownload:) object:url];
        [self.downloadQueue addOperation:operation]; 
	}
	return self;    
}

-(void)startDownload:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
	NSURLConnection* downloadConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	operation.urlConnection = downloadConnection;
	
	if (!downloadConnection) {
		DebugLog(@"failed to create a connection for the downloader");
	}  
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
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

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self performSelectorOnMainThread:@selector(dataSendback) withObject:nil waitUntilDone:YES];
}

-(void)dataSendback {
    @synchronized(self)
    {
        [operation release];
        operation = nil;
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
