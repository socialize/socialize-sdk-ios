//
//  SampleEntityLoader.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 1/11/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_Socialize.h"

@interface SampleEntityLoader : UIViewController
@property (nonatomic, retain) IBOutlet UILabel *entityNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *entityKeyLabel;
@property (nonatomic, retain) id<SocializeEntity> entity;
- (id)initWithEntity:(id<SocializeEntity>)entity;
@end
