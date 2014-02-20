//
//  SZEmailShareData.h
//  Socialize
//
//  Created by Nathaniel Griswold on 8/14/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZShare;

@interface SZEmailShareData : NSObject

@property (nonatomic, retain) id<SZShare> share;
@property (nonatomic, retain) NSDictionary *propagationInfo;
@property (nonatomic, copy) NSString *messageBody;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) BOOL isHTML;

@end
