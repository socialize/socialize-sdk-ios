//
//  NSString+NSString_Socialize.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/23/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "NSString+Socialize.h"
#import "SocializeConfiguration.h"
#import "SocializeObject.h"
#import "SocializeCommonDefinitions.h"
#import "SocializeEntity.h"

@implementation NSString (Socialize)

+(NSString *) stringWithHumanReadableIntegerAndSuffixSinceDate:(NSDate *)date {
	NSInteger timeInterval = (NSInteger) MAX(ceil(-[date timeIntervalSinceNow]), 0);
	
	NSString *suffix;
    NSInteger integer;
	if (timeInterval/(24*3600) > 0) {
        suffix = @"d";
        integer = timeInterval / (24*3600);
	} else if (timeInterval/3600 > 0) {
        suffix = @"h";
        integer = timeInterval / (3600);
	} else if (timeInterval/60 > 0) {
        suffix = @"m";
        integer = timeInterval / 60;
	} else {
        suffix = @"s";
        integer = timeInterval;
    }
	
	return [NSString stringWithFormat:@"%i%@",integer, suffix];
}

+ (NSString*)socializeRedirectURL:(NSString*)path {
    NSString *redirectBaseURL = [[SocializeConfiguration sharedConfiguration] redirectBaseURL];
    NSString *url = [redirectBaseURL stringByAppendingString:path];
    return url;
}

+ (NSString*)stringWithSocializeURLForObject:(id<SocializeObject>)object {
    NSString *suffix = [NSString stringWithFormat:@"e/%d", object.objectID];
    NSString *url = [self socializeRedirectURL:suffix];
    return url;
}

+ (NSString*)stringWithSocializeURLForApplication {
    NSString *apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:kSocializeConsumerKey];
    NSString *suffix = [NSString stringWithFormat:@"a/%@", apiKey];
    NSString *url = [self socializeRedirectURL:suffix];
    return url;
}

+ (NSString*)stringWithTitleForSocializeEntity:(id<SocializeEntity>)entity {
    NSString *title = entity.name;
    if ([title length] == 0) {
        title = entity.key;
    }
    
    return title;
}

+ (NSString*)stringWithSocializeAppDownloadPlug {
    return NSLocalizedString(@"Download the app now to join the conversation.", @"");
}

@end
