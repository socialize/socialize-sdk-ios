@interface CreateCommentsList : UIViewController
@end

// begin-snippet

#import <Socialize/Socialize.h>

@implementation CreateCommentsList

- (IBAction)commentsButtonPressed {
    //create an entity that is unique with your application.
    NSString *entityURL = @"http://www.example.com/object/1234";
    
    UIViewController *commentsController = [SocializeCommentsTableViewController socializeCommentsTableViewControllerForEntity:entityURL];
    [self presentModalViewController:commentsController animated:YES];
}

@end

// end-snippet