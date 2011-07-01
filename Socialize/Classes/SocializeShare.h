//
//  SocializeShare.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeComment.h"


@protocol SocializeShare <SocializeComment>
-(NSInteger)medium;
-(void)setMedium:(NSInteger)medium;
@end

@interface SocializeShare : SocializeComment<SocializeShare> {
    NSInteger _medium;
}

@property (nonatomic, assign) NSInteger medium;

@end
