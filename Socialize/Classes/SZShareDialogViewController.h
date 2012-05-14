//
//  SZShareDialogViewController.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewController.h"

@class SZShareDialogView;

@interface SZShareDialogViewController : SocializeBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet SZShareDialogView *shareDialogView;

@end
