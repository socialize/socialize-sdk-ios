//
//  KIFUITestActor+TestApp.h
//  Socialize
//
//  Created by Sergey Popenko on 9/23/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <KIF/KIF.h>

@interface KIFUITestActor (TestApp)
- (void)initializeTest;
- (void)scrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;
- (void)verifyActionBarLikesAtCount:(NSInteger)count;
@end
