/*
 * UserProfileViewController.h
 * SocializeSDK
 *
 * Created on 7/4/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "SocializeCommonDefinitions.h"
#import "Socialize.h"

@interface UserProfileViewController : UIViewController<SocializeServiceDelegate> {
    IBOutlet UIImageView* userPicture;
    IBOutlet UILabel* userName;
    IBOutlet UILabel* firstName;
    IBOutlet UILabel* lastName;
    IBOutlet UILabel* city;
    IBOutlet UILabel* state;
    IBOutlet UIActivityIndicatorView* progressView;
    
    Socialize* service;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil service: (Socialize*) socService;

@property (nonatomic, retain) IBOutlet UIImageView* userPicture;
@property (nonatomic, retain) IBOutlet UILabel* userName;
@property (nonatomic, retain) IBOutlet UILabel* firstName;
@property (nonatomic, retain) IBOutlet UILabel* lastName;
@property (nonatomic, retain) IBOutlet UILabel* city;
@property (nonatomic, retain) IBOutlet UILabel* state;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* progressView;
@property (nonatomic, assign) Socialize* service;

-(IBAction)doneBtnAction;

@end
