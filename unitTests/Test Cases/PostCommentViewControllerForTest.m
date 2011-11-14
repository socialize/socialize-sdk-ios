/*
 * PostCommentViewControllerForTest.m
 * SocializeSDK
 *
 * Created on 9/15/11.
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

#import "PostCommentViewControllerForTest.h"
#import "CommentMapView.h"
#import <OCMock/OCMock.h>

@implementation PostCommentViewControllerForTest

-(id) initWithEntityUrlString:(NSString*)url keyboardListener:(UIKeyboardListener*) kb locationManager:(SocializeLocationManager *)lm
{
    self = [super initWithNibName:nil bundle:nil entityUrlString:url];
    if(self)
    {
        self.locationManager = lm;
        self.kbListener = kb;
        self.commentTextView = [OCMockObject niceMockForClass: [UITextView class]];
        self.locationText = [OCMockObject niceMockForClass: [UILabel class]];
        self.doNotShareLocationButton = [OCMockObject niceMockForClass: [UIButton class]];
        self.activateLocationButton = [OCMockObject niceMockForClass: [UIButton class]];
        self.mapOfUserLocation = [OCMockObject niceMockForClass: [CommentMapView class]];
    }
    return self;
}

-(void) verify
{
    [(id)self.commentTextView verify];
    [(id)self.locationText verify];
    [(id)self.doNotShareLocationButton verify];
    [(id)self.activateLocationButton verify];
    [(id)self.mapOfUserLocation verify];
}

-(void) startLoadAnimationForView: (UIView*) view;
{
}

-(void) stopLoadAnimation
{
}

- (void)authenticateViaFacebook {
    [self createComment];
}

@end
