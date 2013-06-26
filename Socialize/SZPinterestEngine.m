//
//  SZPinterestEngine.m
//  Socialize
//
//  Created by Sergey Popenko on 6/24/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZPinterestEngine.h"
#import "StringHelper.h"
#import <Pinterest/Pinterest.h>

static SZPinterestEngine *sharedInstance;

@interface SZPinterestEngine()
@property(nonatomic, strong) Pinterest* pinterest;
@property(nonatomic, copy) void (^success)(void);
@property(nonatomic, copy) void (^failure)(void);
@end

@implementation SZPinterestEngine

- (BOOL) isAvailable
{
    return self.pinterest ? [self.pinterest canPinWithSDK] : NO;
}

- (BOOL) handleOpenURL:(NSURL*)url
{
    if (![[url scheme] startsWith:@"pin"]) {
        return NO;
    }
    
    NSInteger index = [[url absoluteString] indexOf:@"pin_success=" from:0];
    NSString* paramsString = [[url absoluteString] substringFrom:index to:[url absoluteString].length];
    
    if ([paramsString isEqual:@"1"] && self.success) {
        self.success();
    }
    
    if ([paramsString isEqual:@"0"] && self.failure) {
        self.failure();
    }

    return YES;
}

- (void) setApplicationId: (NSString*) appID
{
    self.pinterest = [[Pinterest alloc] initWithClientId:appID];
}

- (void) share:(NSString*) message imageURL:(NSURL*) imageUrl sourceUrl:(NSURL*)sourceUrl
       success:(void(^)())success
       failure:(void(^)())failure
{
    if(![self isAvailable])
        return;

    self.success = success;
    self.failure = failure;
    
    [self.pinterest createPinWithImageURL:imageUrl sourceURL:sourceUrl description: message];
}

+ (SZPinterestEngine*) sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[SZPinterestEngine alloc] init];
        }

        return sharedInstance;
    }
}

@end
