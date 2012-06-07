@interface CreateCommentsList : UIViewController
@end

// begin-snippet

#import <Socialize/Socialize.h>

@implementation CreateCommentsList

- (IBAction)commentsButtonPressed {
    //create an entity that is unique with your application.
    NSString *entityURL = @"http://www.example.com/object/1234";
    
    SZCommentsListViewController *commentsList = [SZCommentsListViewController commentsListViewControllerWithEntityKey:entityURL];
    SZNavigationController *nav = [[[SZNavigationController alloc] initWithRootViewController:commentsList] autorelease];
    [self presentModalViewController:nav animated:YES];
}

@end

// end-snippet