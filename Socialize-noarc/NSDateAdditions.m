//
//  NSDateAdditions.m
//  appbuildr
//
//  Created by Fawad Haider  on 12/7/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import "NSDateAdditions.h"


@implementation NSDate (Additions)

-(NSDate*)convertToLocalTime:(NSDate*)sourceDate {
	
	// The Datetime are coming in as EST and we have to convert them to local Time zone.
	NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
	
	NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
	NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
	
	return [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
}

+(NSDateComponents*)differenceInComponents:(NSDate*)endDate{

	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit| 
													NSMonthCalendarUnit| 
													NSDayCalendarUnit | 
													NSHourCalendarUnit |
													NSMinuteCalendarUnit
                                                fromDate:[NSDate date]
												toDate:endDate
                                                options:0];
	return components;
}

//returns string like 5 mins ago, or 12 hours ago or etc 
+(NSString*)getTimeElapsedString:(NSDate*)date{
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:
									NSMinuteCalendarUnit
									fromDate:date
									toDate:[NSDate date]
									options:0];

	if (components.minute < 60){
		return [NSString stringWithFormat:@"%d mins", components.minute]; 
	}
	
	components = [[NSCalendar currentCalendar] components:
										NSHourCalendarUnit
										fromDate:date
										toDate:[NSDate date]
										options:0];
	
	if (components.hour < 24){
		return [NSString stringWithFormat:@"%d hours", components.hour]; 
	}

	components = [[NSCalendar currentCalendar] components:
										NSDayCalendarUnit
												fromDate:date
												   toDate:[NSDate date]
												  options:0];
	
	if (components.day < 60)
		return [NSString stringWithFormat:@"%d days", components.day]; 

	components = [[NSCalendar currentCalendar] components:
				  NSMonthCalendarUnit
					fromDate:date
					toDate:[NSDate date]
					options:0];
	
	return [NSString stringWithFormat:@"%d months", components.month]; 
}

@end