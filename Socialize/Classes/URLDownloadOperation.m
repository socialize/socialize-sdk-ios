//
//  URLDownloadOperation.m
//  appbuildr
//
//  Created by Isaac Mosquera on 6/8/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import "URLDownloadOperation.h"


@implementation URLDownloadOperation
@synthesize urlConnection;

-(void)dealloc{
	self.urlConnection = nil;
	[super dealloc];
}

-(void) cancel 
{
    [self.urlConnection cancel];
	[super cancel];
}

-(id) initWithTarget:(id)target selector:(SEL)sel connection:(NSURLConnection*)connection
{
    self = [super initWithTarget:target selector:sel object:connection];
    if(self)
    {
        self.urlConnection = connection;
    }
    return self;
}

@end
