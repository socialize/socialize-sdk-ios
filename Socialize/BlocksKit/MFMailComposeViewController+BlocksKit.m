//
//  MFMailComposeViewController+BlocksKit.m
//  BlocksKit
//

#import "MFMailComposeViewController+BlocksKit.h"
#import "NSObject+BlocksKit.h"
#import "BKDelegate.h"

static char *kDelegateKey = "MFMailComposeViewControllerDelegate";
static char *kCompletionBlockKey = "MFMailComposeViewControllerCompletion";

#pragma mark Delegate

@interface BKMailComposeViewControllerDelegate : BKDelegate <MFMailComposeViewControllerDelegate>

@end

@implementation BKMailComposeViewControllerDelegate

+ (Class)targetClass {
    return [MFMailComposeViewController class];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    id delegate = controller.mailComposeDelegate;
    if (delegate && [delegate respondsToSelector:@selector(mailComposeController:didFinishWithResult:error:)])
        [controller.mailComposeDelegate mailComposeController:controller didFinishWithResult:result error:error];
    else
        [controller dismissModalViewControllerAnimated:YES];
        
    BKMailComposeBlock block = controller.sz_completionBlock;
    if (block)
        block(result, error);
}

@end

#pragma mark Category

@implementation MFMailComposeViewController (BlocksKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(mailComposeDelegate) withSelector:@selector(sz_bk_mailComposeDelegate)];
        [self swizzleSelector:@selector(setMailComposeDelegate:) withSelector:@selector(sz_bk_setMailComposeDelegate:)];
    });
}

#pragma mark Methods

- (id)sz_bk_mailComposeDelegate {
    return [self associatedValueForKey:kDelegateKey];
}

- (void)sz_bk_setMailComposeDelegate:(id)delegate {
    [self weaklyAssociateValue:delegate withKey:kDelegateKey];
    [self sz_bk_setMailComposeDelegate:[BKMailComposeViewControllerDelegate shared]];
}

#pragma mark Properties

- (BKMailComposeBlock)completionHandler {
    return [self sz_completionBlock];
}

- (void)setCompletionHandler:(BKMailComposeBlock)completionHandler {
    [self setSz_completionBlock:completionHandler];
}
 
- (BKMailComposeBlock)sz_completionBlock {
    BKMailComposeBlock block = [self associatedValueForKey:kCompletionBlockKey];
    return BK_AUTORELEASE([block copy]);
}

- (void)setSz_completionBlock:(BKMailComposeBlock)handler {
    [self sz_bk_setMailComposeDelegate:[BKMailComposeViewControllerDelegate shared]];
    [self associateCopyOfValue:handler withKey:kCompletionBlockKey];
}

@end
