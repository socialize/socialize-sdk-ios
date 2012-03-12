//
//  SocializeCommentCreatorTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 3/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeCommentCreator.h"
#import "SocializeActivityCreatorTests.h"

@interface SocializeCommentCreatorTests : SocializeActivityCreatorTests
@property (nonatomic, retain) SocializeCommentCreator *commentCreator;
@property (nonatomic, retain) id mockOptions;
@property (nonatomic, retain) id mockComment;

@end
