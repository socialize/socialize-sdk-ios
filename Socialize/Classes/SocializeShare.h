//
//  SocializeShare.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/1/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeComment.h"

/**Protocol for socialize share object representation.*/
@protocol SocializeShare <SocializeComment>
/**Get share type.*/
-(NSInteger)medium;

/**
 Set share type.
 @param medium Share type.
 */
-(void)setMedium:(NSInteger)medium;
@end

/**Private implementation of <SocializeShare> protocol*/
@interface SocializeShare : SocializeComment<SocializeShare>

+ (SocializeShare*)shareWithEntity:(id<SocializeEntity>)entity text:(NSString*)text medium:(SocializeShareMedium)medium;

/**Share type*/
@property (nonatomic, assign) NSInteger medium;

@end
