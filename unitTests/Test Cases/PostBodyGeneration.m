/*
 * PostBodyGeneration.m
 * SocializeSDK
 *
 * Created on 6/13/11.
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

#import "PostBodyGeneration.h"
#import "NSMutableData+PostBody.h"

@interface PostBodyGeneration()
    
@end

@implementation PostBodyGeneration

-(void) addSimpleParameter: (NSMutableData*) body withValue: (id) value withKey: (id) key
{      
    [body appendData:
                    [
                     [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
                     dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
    
    [body appendData:
                    [
                      value
                      dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
    
    [body appendData:
                    [
                      [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary]
                      dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
}

-(void) addImageParameter: (NSMutableData*) body withValue: (id) value withKey: (id) key
{      
    NSData* imageData = UIImagePNGRepresentation((UIImage*)value);
    [body appendData:
                    [
                     [NSString stringWithFormat:@"Content-Disposition: form-data; filename=\"%@\"\r\n", key]
                     dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
    
    [body appendData:
                    [
                     [NSString stringWithString:@"Content-Type: image/png\r\n\r\n"]
                     dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
    
    [body appendData:imageData];
    
    [body appendData:
                    [
                     [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary]
                     dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
}

-(void) addDataParameter: (NSMutableData*) body withValue: (id) value withKey: (id) key
{      
    [body appendData:
                    [
                     [NSString stringWithFormat: @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]
                     dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
    
    [body appendData:
                    [
                     [NSString stringWithString:@"Content-Type: content/unknown\r\n\r\n"]
                     dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
    
    [body appendData:(NSData*)value];
    
    [body appendData:
                    [
                     [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary]
                     dataUsingEncoding:NSUTF8StringEncoding
                    ]
    ];
}

-(void) testPostBodyWithSimpleParams
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   nil];
    
    NSMutableData* expetedResult = [NSMutableData dataWithData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]
                                             dataUsingEncoding:NSUTF8StringEncoding]];

    [self addSimpleParameter:expetedResult withValue:@"parameter_value_2" withKey:@"parameter_key_2"];
    [self addSimpleParameter:expetedResult withValue:@"parameter_value_1" withKey:@"parameter_key_1"];
    
    NSData* actualResult = [NSMutableData generatePostBodyWithParams:params];

    GHAssertTrue([actualResult isEqualToData:expetedResult], @"Should be equal");
}

-(void) testPostBodyWithImageParams
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   [[[UIImage alloc] init] autorelease], @"parameter_key_3",
                                   nil];
    
    NSMutableData* expetedResult = [NSMutableData dataWithData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]
                                                                dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self addSimpleParameter:expetedResult withValue:@"parameter_value_2" withKey:@"parameter_key_2"];
    [self addSimpleParameter:expetedResult withValue:@"parameter_value_1" withKey:@"parameter_key_1"];
    [self addImageParameter:expetedResult withValue:[params objectForKey:@"parameter_key_3"] withKey:@"parameter_key_3"];
    
    NSData* actualResult = [NSMutableData generatePostBodyWithParams:params];
    
    GHAssertTrue([actualResult isEqualToData:expetedResult], @"Should be equal");
}

-(void) testPostBodyWithDataParams
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"parameter_value_1", @"parameter_key_1",
                                   @"parameter_value_2", @"parameter_key_2",
                                   [[[NSData alloc] init] autorelease], @"parameter_key_3",
                                   nil];
    NSMutableData* expetedResult = [NSMutableData dataWithData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]
                                                                dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self addSimpleParameter:expetedResult withValue:@"parameter_value_2" withKey:@"parameter_key_2"];
    [self addSimpleParameter:expetedResult withValue:@"parameter_value_1" withKey:@"parameter_key_1"];
    [self addDataParameter:expetedResult withValue:[params objectForKey:@"parameter_key_3"] withKey:@"parameter_key_3"];
    
    NSData* actualResult = [NSMutableData generatePostBodyWithParams:params];
    
    GHAssertTrue([actualResult isEqualToData:expetedResult], @"Should be equal");
}

-(void) testPostBodyWithNilParams
{
    NSMutableData* expetedResult = [NSMutableData dataWithData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]
                                                                dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData* actualResult = [NSMutableData generatePostBodyWithParams:nil];
    
    GHAssertTrue([actualResult isEqualToData:expetedResult], @"Should be equal");
}

@end
