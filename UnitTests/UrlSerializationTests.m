/*
 * UrlSerializationTests.m
 * SocializeSDK
 *
 * Created on 6/10/11.
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

#import "UrlSerializationTests.h"
#import "NSString+UrlSerialization.h"


@implementation UrlSerializationTests

-(void) testSerializeParamsWithDefaultSendMetod
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];

    NSString* urlPrefix = @"http:////test.service.com/method";
    NSString* expectedResult = @"http:////test.service.com/method?parameter_key_2=parameter_value_2&parameter_key_1=parameter_value_1";

    NSString* actualResult = [NSString serializeURL:urlPrefix params:params];
    
    GHAssertEqualStrings(expectedResult, actualResult, @"Should be equal"); 
}

-(void) testSerializeParamsWithGetMethod
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];
    
    NSString* urlPrefix = @"http:////test.service.com/method";
    NSString* expectedResult = @"http:////test.service.com/method?parameter_key_2=parameter_value_2&parameter_key_1=parameter_value_1";
    
    NSString* actualResult = [NSString serializeURL:urlPrefix params:params httpMethod:@"GET"];
    
    GHAssertEqualStrings(expectedResult, actualResult, @"Should be equal"); 
}

-(void) testSerializeParamsWithPostMethod
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];
    
    NSString* urlPrefix = @"http:////test.service.com/method";
    NSString* expectedResult = @"http:////test.service.com/method?parameter_key_2=parameter_value_2&parameter_key_1=parameter_value_1";
    
    NSString* actualResult = [NSString serializeURL:urlPrefix params:params httpMethod:@"POST"];
    
    GHAssertEqualStrings(expectedResult, actualResult, @"Should be equal");     
}

-(void) testSerializeParamsWithPostMethodAndObjectsInParamsList
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   [[[UIImage alloc] init] autorelease], @"parameter_key_3",
                                   [[[NSData alloc] init] autorelease], @"parameter_key_4",
                                   nil];
    
    NSString* urlPrefix = @"http:////test.service.com/method";
    NSString* expectedResult = @"http:////test.service.com/method?parameter_key_2=parameter_value_2&parameter_key_1=parameter_value_1";
    
    NSString* actualResult = [NSString serializeURL:urlPrefix params:params httpMethod:@"POST"];
    
    GHAssertEqualStrings(expectedResult, actualResult, @"Should be equal");     
}

-(void) testSerializeParamsWithGetMethodAndObjectsInParamsList
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   [[[UIImage alloc] init] autorelease], @"parameter_key_3",
                                   [[[NSData alloc] init] autorelease], @"parameter_key_4",
                                   nil];
    
    NSString* urlPrefix = @"http:////test.service.com/method";
    NSString* expectedResult = @"http:////test.service.com/method?parameter_key_2=parameter_value_2&parameter_key_1=parameter_value_1";
    
    NSString* actualResult = [NSString serializeURL:urlPrefix params:params httpMethod:@"GET"];
    
    GHAssertEqualStrings(expectedResult, actualResult, @"Should be equal");     
}

-(void) testSerializeNilParams
{   
    NSString* urlPrefix = @"http:////test.service.com/method";
    NSString* expectedResult = @"http:////test.service.com/method?";
    
    NSString* actualResult = [NSString serializeURL:urlPrefix params:nil httpMethod:@"GET"];
    
    GHAssertEqualStrings(expectedResult, actualResult, @"Should be equal");     
}

-(void) testSerializeNilPrefix
{       
    GHAssertTrue(nil == [NSString serializeURL:nil params:nil httpMethod:@"GET"], @"Should be nil");
}

//-(void) testParseUrlParams
//{
//    NSDictionary* actualResult =  [NSString parseURLParams:@"http:////test.service.com/method?parameter_key_2=parameter_value_2&parameter_key_1=parameter_value_1"];
//}

@end
