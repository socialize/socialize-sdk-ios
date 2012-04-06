//
//  MFMessageComposeViewController+BlocksKit.m
//  BlocksKit
//

#import "MFMessageComposeViewController+BlocksKit.h"
#import "NSObject+BlocksKit.h"
#import "BKDelegate.h"

static char *kDelegateKey = "MFMessageComposeViewControllerDelegate";
static char *kCompletionBlockKey = "MFMessageComposeViewControllerCompletion";

#pragma mark Delegate

@interface BKMessageComposeViewControllerDelegate : BKDelegate <MFMessageComposeViewControllerDelegate>

@end

@implementation BKMessageComposeViewControllerDelegate

+ (Class)targetClass {
    return [MFMessageComposeViewController class];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    id delegate = controller.messageComposeDelegate;
    if (delegate && [delegate respondsToSelector:@selector(messageComposeViewController:didFinishWithResult:)])
        [delegate messageComposeViewController:controller didFinishWithResult:result];
    else
        [controller dismissModalViewControllerAnimated:YES];
    
    BKMessageComposeBlock block = controller.sz_completionBlock;
    if (block)
        block(result);
}

@end

#pragma mark Category

@implementation MFMessageComposeViewController (BlocksKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(messageComposeDelegate) withSelector:@selector(socialize_bk_messageComposeDelegate)];
        [self swizzleSelector:@selector(setMessageComposeDelegate:) withSelector:@selector(socialize_bk_setMessageComposeDelegate:)];
    });
}

#pragma mark Methods

- (id)socialize_bk_messageComposeDelegate {
    return [self associatedValueForKey:kDelegateKey];
}

- (void)socialize_bk_setMessageComposeDelegate:(id)delegate {
    [self weaklyAssociateValue:delegate withKey:kDelegateKey];
    [self socialize_bk_setMessageComposeDelegate:[BKMessageComposeViewControllerDelegate shared]];
}

#pragma mark Properties

- (BKMessageComposeBlock)completionHandler {
    return [self sz_completionBlock];
}

- (void)setCompletionHandler:(BKMessageComposeBlock)completionHandler {
    [self setSz_completionBlock:completionHandler];
}

- (BKMessageComposeBlock)sz_completionBlock {
    BKMessageComposeBlock block = [self associatedValueForKey:kCompletionBlockKey];
    return BK_AUTORELEASE([block copy]);
}

- (void)setSz_completionBlock:(BKMessageComposeBlock)handler {
    [self socialize_bk_setMessageComposeDelegate:[BKMessageComposeViewControllerDelegate shared]];
    [self associateCopyOfValue:handler withKey:kCompletionBlockKey];
}

@end

