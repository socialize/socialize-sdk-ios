//
//  NSDateAdditions.h
//  appbuildr
//
//  Created by Fawad Haider  on 12/7/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Additions) 

-(NSDate*)convertToLocalTime:(NSDate*)sourceDate;
+(NSDateComponents*)differenceInComponents:(NSDate*)endDate;
+(NSString*)getTimeElapsedString:(NSDate*)date;
@end
