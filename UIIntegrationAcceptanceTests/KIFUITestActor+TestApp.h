//
//  KIFUITestActor+TestApp.h
//  Socialize
//
//  Created by Sergey Popenko on 9/23/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <KIF/KIF.h>

@interface KIFUITestActor (TestApp)
- (void)verifyActionBarLikesAtCount:(NSInteger)count;
- (void)openActionBarExample;
- (void)showUserProfile;
- (void)openEditProfile;
@end


@interface KIFUITestActor (Utils)
- (void)initializeTest;
- (void)scrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;
@end