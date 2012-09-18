//
//  SZViewControllerWrapper.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/10/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZViewControllerWrapper.h"

@interface SZViewControllerWrapper ()

@end

@implementation SZViewControllerWrapper

- (id)init {
    if (self = [super init]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.modalPresentationStyle = UIModalPresentationFormSheet;
        }
    }
    
    return self;
}

@end
