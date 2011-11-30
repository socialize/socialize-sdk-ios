/*
 * SocializeBaseViewController.h
 * SocializeSDK
 *
 * Created on 9/26/11.
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
#import "_Socialize.h"

@class SocializeShareBuilder;
@class SocializeLoadingView;
@class ImagesCache;

@interface SocializeBaseViewController : UIViewController<SocializeServiceDelegate, UIAlertViewDelegate, UINavigationControllerDelegate> {
    @private 
    SocializeLoadingView*  _loadingIndicatorView;
}
@property(nonatomic, retain) UINavigationController* authViewController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) UIBarButtonItem *sendButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) UIAlertView *genericAlertView;
@property (nonatomic, retain) UIAlertView *sendActivityToFacebookFeedAlertView;
@property (nonatomic, retain) SocializeShareBuilder *shareBuilder;
@property (nonatomic, retain) ImagesCache *imagesCache;
@property (nonatomic, retain) NSBundle *bundle;

-(void) showAlertWithText: (NSString*)allertMsg andTitle: (NSString*)title;
-(void) startLoading;
-(void) stopLoading;
-(void) startLoadAnimationForView: (UIView*) view;
-(void) stopLoadAnimation;
-(void)performAutoAuth;
-(void) afterLoginAction;
-(BOOL)shouldAutoAuthOnAppear;
- (UIView*)showLoadingInView;
- (void)authenticateWithFacebook;
- (void)saveButtonPressed:(UIButton*)button;
- (void)editButtonPressed:(UIButton*)button;
- (void)doneButtonPressed:(UIButton*)button;
- (void)sendButtonPressed:(UIButton*)button;
- (void)cancelButtonPressed:(UIButton*)button;
- (void)sendActivityToFacebookFeed:(id<SocializeActivity>)activity;
- (void)sendActivityToFacebookFeedSucceeded;
- (void)sendActivityToFacebookFeedFailed:(NSError*)error;
- (void)sendActivityToFacebookFeedCancelled;
- (UIBarButtonItem*)createLeftNavigationButtonWithCaption:(NSString*)caption;
- (void)getCurrentUser;
- (void)didGetCurrentUser:(id<SocializeFullUser>)fullUser;
- (void)loadImageAtURL:(NSString*)imageURL
          startLoading:(void(^)())startLoadingBlock
           stopLoading:(void(^)())stopLoadingBlock
            completion:(void(^)(UIImage *image))completionBlock;

@end