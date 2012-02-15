//
//  OCMockObject+SocializeHelpers.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "OCMock/OCMock.h"

@interface OCMockRecorder (SocializeHelpers)
- (id)andReturnFromBlock:(id (^)())block;

@end
