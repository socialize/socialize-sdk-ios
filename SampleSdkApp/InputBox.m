/*
 * InputBox.m
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

#import "InputBox.h"


@implementation InputBox
@synthesize inputMsg = _inputMsg;
@synthesize inputField = _inputField;

-(id)init
{
    self = [super init];
    if(self)
    {
        _inputField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
        [_inputField setBackgroundColor:[UIColor whiteColor]];
        _inputField.text = @"";   
        _inputField.accessibilityLabel = @"Input Field";
        _inputField.autocorrectionType =  UITextAutocorrectionTypeNo;
        _inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        lock = [[NSCondition alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [_inputField release];
    [_inputMsg  release];
    [lock release];
    [super dealloc];
}

-(void)showInputMessageWithTitle:(NSString*)title andPlaceholder:(NSString*)placeholder
{
    [_inputField setPlaceholder:placeholder];
    
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:title
                                                     message:@"\n\n" // IMPORTANT
                                                    delegate:self 
                                           cancelButtonTitle:@"Cancel" 
                                           otherButtonTitles:@"Enter", nil];
    
    [prompt addSubview:_inputField];
    
    [prompt show];
    [prompt release];
    
    // set cursor and show keyboard
    [_inputField becomeFirstResponder];
    
    shouldKeepRunning = YES;        // global
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    // FIXME -- KIF is hiccupping on the manual runloop spin
#if RUN_KIF_TESTS
    while (shouldKeepRunning) {
        [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
#else
    while (shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && [_inputField.text length] >0){
        self.inputMsg = _inputField.text;
    }
    
    _inputField.text = @"";
    shouldKeepRunning = NO;
}

@end
