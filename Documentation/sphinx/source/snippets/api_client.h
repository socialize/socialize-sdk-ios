#import <Socialize/Socialize.h>

@interface SampleAPIClient : NSObject <SocializeServiceDelegate>
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) id<SocializeLike> like;
@end
