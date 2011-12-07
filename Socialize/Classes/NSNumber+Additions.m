//
//  NSNumber+Additions.m
//  appbuildr
//
//  Created by Fawad Haider  on 2/16/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "NSNumber+Additions.h"


@implementation NSNumber(SocializeFormattingExtension)


+(NSString*)formatMyNumber:(NSNumber*)mynumber ceiling:(NSNumber*)ceiling{
	
	if ([mynumber unsignedIntValue] < [ceiling unsignedIntValue]){
		NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
		[numberFormatter setGroupingSize:3];
		[numberFormatter setGroupingSeparator:@","];
		[numberFormatter setUsesGroupingSeparator:YES];
		return [numberFormatter stringFromNumber: mynumber];
	}
	
	NSString* stringValue = [mynumber stringValue];
	NSInteger noOfDigits = [stringValue length];
	
	NSInteger kiloOrMil = noOfDigits / 3.0f ;
	char kiloOrMilChar;
	
	if (kiloOrMil == 1){
		kiloOrMilChar = 'K';
	}
	else if (kiloOrMil == 2) {
		kiloOrMilChar = 'M';
	}
	else if (kiloOrMil >= 3) {
		kiloOrMilChar = 'G';
	}
    else {
        kiloOrMilChar = '?';
    }
	
	NSInteger noOfDigitsToShow = noOfDigits % 3;
	NSString * myFinalStr = [NSString stringWithFormat:@"%@%c+", [stringValue substringToIndex:noOfDigitsToShow ], kiloOrMilChar];
	return myFinalStr;
}

@end
