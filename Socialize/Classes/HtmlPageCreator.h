//
//  HtmlPageCreator.h
//  appbuildr
//
//  Created by Sergey Popenko on 4/15/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HtmlPageCreator : NSObject {
    NSMutableString* html;
}

-(BOOL) loadTemplate: (NSString*) filePath;
-(void) addInformation: (NSString*) info forTag: (NSString*) tag;

@property (nonatomic, readonly) NSString* html;

@end
