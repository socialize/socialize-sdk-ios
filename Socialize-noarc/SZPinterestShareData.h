//
//  SZPinterestShareData.h
//  Socialize
//
//  Created by Sergey Popenko on 6/24/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZShare;

@interface SZPinterestShareData : NSObject

@property (nonatomic, retain) id<SZShare> share;
@property (nonatomic, retain) NSDictionary *propagationInfo;
@property (nonatomic, copy)   NSString *body;

@end
