// Store the action bar in a property on your view controller

#import <Socialize/Socialize.h>

@interface CreateActionBarViewController : UIViewController
@property (nonatomic, retain) SZActionBar *actionBar;
@property (nonatomic, retain) id<SZEntity> entity;
@end
