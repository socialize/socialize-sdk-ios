//
//  _SZShareDialogViewController.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/19/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZBaseShareViewController.h"

@interface _SZShareDialogViewController : SZBaseShareViewController

@property (nonatomic, copy) void (^completionBlock)(NSArray *shares);
@property (nonatomic, copy) void (^cancellationBlock)();
@property (nonatomic, assign) BOOL dontShowComposer;

@end
