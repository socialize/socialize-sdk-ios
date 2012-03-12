//
//  SocializeShareCreatorTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityCreatorTests.h"
#import "SocializeShareCreator.h"

@interface SocializeShareCreatorTests : SocializeActivityCreatorTests
@property (nonatomic, retain) SocializeShareCreator *shareCreator;
@property (nonatomic, retain) id mockOptions;
@property (nonatomic, retain) id mockShare;

@end
