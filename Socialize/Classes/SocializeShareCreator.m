//
//  SocializeShareCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeShareCreator.h"
#import "_Socialize.h"

@implementation SocializeShareCreator

+ (void)createShare:(id<SocializeShare>)share
            options:(SocializeShareOptions*)options
            display:(id)display
            success:(void(^)(id<SocializeShare>))success
            failure:(void(^)(NSError *error))failure {
    
    SocializeShareCreator *creator = [[[SocializeShareCreator alloc] initWithActivity:share
                                                                              options:options
                                                                         displayProxy:nil
                                                                              display:display] autorelease];
    creator.activitySuccessBlock = success;
    creator.failureBlock = failure;
    [SocializeAction executeAction:creator];
}

- (id<SocializeShare>)share {
    return (id<SocializeShare>)self.activity;
}

- (NSString*)textForFacebook {
    NSString *objectURL = [NSString stringWithSocializeURLForObject:self.share.entity];
    return [NSMutableString stringWithFormat:@"%@: \n %@", self.share.text, objectURL];
}

- (void)createActivityOnSocializeServer {
    [self.socialize createShare:self.share];
}

- (void)service:(SocializeService *)service didCreate:(id)objectOrObjects {
    NSAssert([objectOrObjects conformsToProtocol:@protocol(SocializeShare)], @"Not a share");
    
    [self succeedServerCreateWithActivity:objectOrObjects];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self failServerCreateWithError:error];
}


@end
