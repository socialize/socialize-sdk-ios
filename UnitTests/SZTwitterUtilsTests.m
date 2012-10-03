//
//  SZTwitterUtilsTests.m
//  Socialize
//
//  Created by Nathaniel Griswold on 10/3/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZTwitterUtilsTests.h"
#import "SocializeObjects.h"

@implementation SZTwitterUtilsTests

- (SZEntity*)entityWithLongName {
    
    // 160 'a's
    NSString *name = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    return [SZEntity entityWithKey:@"key" name:name];
}

- (NSString*)longText {
    return @"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
}

- (void)fakeTwitterActivity:(id<SZActivity>)activity {
    NSString *entityURL = @"http://besoci.al/d3prt";
    NSDictionary *propagationInfoResponse = @{ @"twitter": @{ @"entity_url": entityURL } };
    activity.propagationInfoResponse = propagationInfoResponse;
    [activity setFromServer:YES];
}

- (void)testTruncationOfCommentWithLongNameAndShortText {
    SZEntity *entity = [self entityWithLongName];
    NSString *text = @"short";
    SZComment *comment = [SZComment commentWithEntity:entity text:text];
    [self fakeTwitterActivity:comment];
    NSString *twitterText = [SZTwitterUtils defaultTwitterTextForActivity:comment];
    
    GHAssertTrue([twitterText length] <= 140, @"Too long for twitter");
}

- (void)testTruncationOfCommentWithShortNameAndLongText {
    SZEntity *entity = [SZEntity entityWithKey:@"key" name:@"shortname"];
    NSString *text = [self longText];
    SZComment *comment = [SZComment commentWithEntity:entity text:text];
    [self fakeTwitterActivity:comment];
    NSString *twitterText = [SZTwitterUtils defaultTwitterTextForActivity:comment];
    
    GHAssertTrue([twitterText length] <= 140, @"Too long for twitter");
}

- (void)testTruncationOfCommentWithLongNameAndLongText {
    SZEntity *entity = [self entityWithLongName];
    NSString *text = [self longText];
    SZComment *comment = [SZComment commentWithEntity:entity text:text];
    [self fakeTwitterActivity:comment];
    NSString *twitterText = [SZTwitterUtils defaultTwitterTextForActivity:comment];
    
    GHAssertTrue([twitterText length] <= 140, @"Too long for twitter");
}

@end
