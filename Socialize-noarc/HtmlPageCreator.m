//
//  HtmlPageCreator.m
//  appbuildr
//
//  Created by Sergey Popenko on 4/15/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "HtmlPageCreator.h"


@implementation HtmlPageCreator
@synthesize html;

-(BOOL) loadTemplate: (NSString*) filePath
{
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if(readHandle == nil)
    {
        return NO;
    }
        
    html = [[NSMutableString alloc] init];
    [html appendFormat: @"%@", [[[NSString alloc] initWithData: 
                                           [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding] autorelease]];  
    return YES;
}

-(void)dealloc
{
    [html release]; html = nil;
    [super dealloc];
}

-(void) addInformation: (NSString*) info forTag: (NSString*) tag
{
    if( info && tag ) {
        [html replaceOccurrencesOfString: tag withString:info options:NSLiteralSearch range:NSMakeRange(0, [html length])];
    }
}

@end
