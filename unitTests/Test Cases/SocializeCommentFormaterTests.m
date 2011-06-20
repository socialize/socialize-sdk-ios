/*
 * SocializeCommentFormaterTests.m
 * SocializeSDK
 *
 * Created on 6/20/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * See Also: http://gabriel.github.com/gh-unit/
 */

#import "SocializeCommentFormaterTests.h"
#import "SocializeObjectFactory.h"


@implementation SocializeCommentFormaterTests

-(void) setUpClass
{
    [super setUpClass];
    _commentFormater = [[SocializeCommentJSONFormatter alloc] initWithFactory:[[SocializeObjectFormatter new]autorelease]];
}

-(void) tearDownClass
{
    [_commentFormater release]; _commentFormater = nil;
    [super tearDownClass];
}

//- (void)testCommentIdsToJsonString 
//{
//  
//    NSArray* ids = [NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
//    NSString* expectedResult = @"{\"ids\":[1,2]}";
//        
//    NSString* actualResult =  [_commentFormater   commentIdsToJsonString:ids];
//    GHAssertEqualStrings(expectedResult, actualResult, nil);                        
//}
//
//-(void) testEntryKeyToJsonString
//{
//    NSString* expectedResult = @"{\"key\":\"http://www.example.com/interesting-story/\"}";
//    NSString* entryKey = @"http://www.example.com/interesting-story/";
//    
//    NSString* actualResult = [_commentFormater  entryKeyToJsonString: entryKey];
//    GHAssertEqualStrings(expectedResult, actualResult, nil);                        
//}
//
//-(void) testCommentsFromDictionary
//{
//    NSString* expectedResult = @"[{\"entity\":\"http://www.example.com/interesting-story/\",\"text\":\"this was a great story\"}]";   
//    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"this was a great story", @"http://www.example.com/interesting-story/",
//                            nil];
//    
//    NSString* actualResult = [_commentFormater commentsFromDictionary:params];
//    GHAssertEqualStrings(expectedResult, actualResult, nil);                       
//}
//
//-(void) testFromJsonToSingleComment
//{
//    NSString* imputJsonString = [self helperGetJSONStringFromFile: @"comment_single_response.json"];
//    [_commentFormater fromJsonToObject:imputJsonString];
//}

@end
