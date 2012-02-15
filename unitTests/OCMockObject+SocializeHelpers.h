//
//  OCMockObject+SocializeHelpers.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/13/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "OCMock/OCMock.h"

@interface OCMockObject ()
- (id)realObject;
@end

@interface OCMockObject (SocializeHelpers)

- (id)makeNice;

@end
