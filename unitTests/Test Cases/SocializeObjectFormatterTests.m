//
//  SocializeObjectParserTests.m
//  SocializeSDK
//
//  Created by William Johnson on 5/23/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//
#import "JSONKit.h"
#import "SocializeObjectFormatterTests.h"
#import "SocializePOOCObjectFactory.h"


@interface SocializeObjectFormatterTests()
-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName;
@end

@implementation SocializeObjectFormatterTests

- (void)setUpClass 
{
    _factory =[[SocializePOOCObjectFactory alloc]init];

}


- (void)tearDownClass 
{
    [_factory release];   
}

-(id)mockFactory
{
    id mockFactory = [OCMockObject mockForClass:[SocializeObjectFactory class]];
    return  mockFactory;
}

//Put this in a unitTestHelper Category for Formatters
-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName
{
    NSString * JSONFilePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",@"JSON-RequestAndResponse-TestFiles", fileName ] ofType:nil];
    
    
    NSString * JSONString = [NSString stringWithContentsOfFile:JSONFilePath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
    
    return  JSONString;
}
@end
