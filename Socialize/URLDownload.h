//
//  URLDownload.h
//  HitFix
//
//  Created by PointAbout Developer on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "URLDownloadOperation.h"

@interface URLDownload : NSObject {
    NSString        *urlForDownload;
	NSObject *requestedObject;
	SEL notificationSelector;
	NSObject *objectIdentifier;
	NSMutableData *urlData;
	URLDownloadOperation * operation;
}

@property(nonatomic, retain) NSString* urlForDownload;
@property(nonatomic, retain) NSObject* objectIdentifier;
@property(nonatomic, assign) NSObject* requestedObject;
@property(nonatomic, retain) NSMutableData *urlData;
@property(nonatomic, readonly) URLDownloadOperation * operation;

+ (NSOperationQueue *)downloadQueue;
- (id) initWithURL:(NSString *)url sender:(NSObject *)caller selector:(SEL)Selector tag:(NSObject *)downloadTag;
- (void) cancelDownload;

@end
